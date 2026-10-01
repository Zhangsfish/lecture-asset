import ArchiveCore
import CryptoKit
import Foundation
import Vision
import Darwin.Mach

enum ArchivePhase: String, Codable, Sendable {
    case processing, paused, failed, ready
}

struct ArchiveState: Codable, Sendable {
    let jobId: UUID
    let archiveId: UUID
    var phase: ArchivePhase
    var ocrByPage: [Int: OCRResult]
    var memoryAfterPage: [Int: UInt64]
    var memoryPeakPage: [Int: UInt64]
    var pdfMemoryAfterPage: [Int: UInt64]
    var pdfMemoryPeakPage: [Int: UInt64]
    var pdfImageSha256ByPage: [Int: String]?
    var zipShareReceipt: ZIPShareReceipt? // Optional for pre-S03 archive checkpoints.
    var zipName: String?
    var pdfName: String?
    var zipSha256: String?
    var pdfSha256: String?
    var failureCode: String?
    var failureStage: String?

    init(jobId: UUID) {
        self.jobId = jobId; archiveId = UUID(); phase = .processing
        ocrByPage = [:]; memoryAfterPage = [:]; memoryPeakPage = [:]
        pdfMemoryAfterPage = [:]; pdfMemoryPeakPage = [:]
    }

    var completedOCRCount: Int { ocrByPage.count }
}

enum ArchiveStore {
    static func url(for job: ProcessingJob) throws -> URL {
        try JobStore.directory(for: job).appending(path: "archive.json")
    }

    static func save(_ state: ArchiveState, job: ProcessingJob) throws {
        let encoder = JSONEncoder(); encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(state).write(to: url(for: job), options: .atomic)
    }

    static func load(job: ProcessingJob) throws -> ArchiveState? {
        let location = try url(for: job)
        guard FileManager.default.fileExists(atPath: location.path) else { return nil }
        let decoder = JSONDecoder(); decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ArchiveState.self, from: Data(contentsOf: location))
    }

    static func outputDirectory(job: ProcessingJob) throws -> URL {
        try JobStore.directory(for: job).appending(path: "exports", directoryHint: .isDirectory)
    }

    static func verifiedZIPIdentity(_ state: ArchiveState, job: ProcessingJob) throws -> (ZIPShareIdentity, URL) {
        guard try verifyReady(state, job: job), let name = state.zipName,
              let expectedHash = state.zipSha256 else { throw SourceCleanupFailure.archiveChanged }
        let url = try outputDirectory(job: job).appending(path: name)
        let properties = try url.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey])
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
        guard properties.isRegularFile == true, properties.isSymbolicLink != true,
              let number = attributes[.systemFileNumber] as? NSNumber, number.uint64Value > 0,
              try ArchiveBuilder.measure(url).hash == expectedHash else {
            throw SourceCleanupFailure.archiveChanged
        }
        return (ZIPShareIdentity(jobId: job.id, archiveId: state.archiveId,
                                 filename: name, sha256: expectedHash,
                                 fileNumber: number.uint64Value), url)
    }

    static func verifiedPDFURL(_ state: ArchiveState, job: ProcessingJob) throws -> URL {
        guard try verifyReady(state, job: job), let name = state.pdfName else {
            throw SourceCleanupFailure.archiveChanged
        }
        let url = try outputDirectory(job: job).appending(path: name)
        let properties = try url.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey])
        guard properties.isRegularFile == true, properties.isSymbolicLink != true else {
            throw SourceCleanupFailure.archiveChanged
        }
        return url
    }

    static func verifyReady(_ state: ArchiveState, job: ProcessingJob) throws -> Bool {
        guard state.phase == .ready, let zipName = state.zipName, let pdfName = state.pdfName,
              let zipHash = state.zipSha256, let pdfHash = state.pdfSha256,
              (zipName as NSString).lastPathComponent == zipName,
              (pdfName as NSString).lastPathComponent == pdfName else { return false }
        let directory = try outputDirectory(job: job)
        let zip = directory.appending(path: zipName)
        let pdf = directory.appending(path: pdfName)
        guard FileManager.default.fileExists(atPath: zip.path), FileManager.default.fileExists(atPath: pdf.path),
              try ArchiveBuilder.measure(zip).hash == zipHash,
              try ArchiveBuilder.measure(pdf).hash == pdfHash,
              let schema = Bundle.main.url(forResource: "manifest-v1.schema", withExtension: "json") else { return false }
        let inputs = try job.pages.map { page -> ArchiveInputPage in
            guard let ocr = state.ocrByPage[page.pageIndex], let width = page.width,
                  let height = page.height, let bytes = page.jpegBytes, let sha = page.sha256 else {
                throw ArchiveFailure.invalid("missing archive page")
            }
            let input = ArchivePage(number: page.pageIndex, selectionIndex: page.selectionIndex,
                                    capturedAt: page.capturedAt.map(ArchiveDate.iso), width: width,
                                    height: height, bytes: bytes, sha256: sha,
                                    isLivePhoto: page.isLivePhoto, ocr: ocr.normalizedForManifest())
            let archiveInput = ArchiveInputPage(sourceURL: try JobStore.imageURL(for: page, in: job), record: input)
            try ArchiveBuilder.verifyImage(archiveInput)
            return archiveInput
        }
        let records = inputs.map(\.record)
        let title = "Lecture \(ArchiveDate.titleDate(captured: job.pages.map(\.capturedAt), jobCreatedAt: job.createdAt))"
        let manifest = Manifest(archiveId: state.archiveId, title: title,
                                createdAt: ArchiveDate.iso(job.createdAt), pages: records,
                                files: archiveFileList(title: title, records: records))
        try ArchiveValidator.validateZIP(at: zip, rootName: String(zipName.dropLast(7)), expected: manifest, schemaURL: schema)
        try CompanionPDF.validate(at: pdf, pages: inputs,
                                  embeddedJPEGHashes: state.pdfImageSha256ByPage)
        return true
    }

    private static func archiveFileList(title: String, records: [ArchivePage]) -> [ArchiveFile] {
        // README and lecture hashes are deterministic; JPEG hashes are frozen.
        func hash(_ string: String, path: String) -> ArchiveFile {
            let data = Data(string.utf8)
            let digest = SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
            return ArchiveFile(path: path, bytes: data.count, sha256: digest)
        }
        return [hash(MarkdownDocument.readme, path: "README.md"),
                hash(MarkdownDocument.lecture(title: title, pages: records), path: "lecture.md")] +
               records.map { ArchiveFile(path: $0.image, bytes: $0.bytes, sha256: $0.sha256) }
    }
}

enum VisionOCR {
    static func recognize(_ url: URL) -> OCRResult {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        let revision = request.revision
        let supported = (try? request.supportedRecognitionLanguages()) ?? []
        let preferred = ["zh-Hans", "en-US", "en-GB", "en"]
        let languages = preferred.filter { supported.contains($0) }
        request.recognitionLanguages = languages.isEmpty ? Array(supported.prefix(1)) : languages
        do {
            let handler = VNImageRequestHandler(url: url, options: [:])
            try autoreleasepool { try handler.perform([request]) }
            let blocks: [OCRBlock] = (request.results ?? []).compactMap { observation in
                guard let candidate = observation.topCandidates(1).first else { return nil }
                let box = observation.boundingBox
                guard let bbox = OCRGeometry.visionBBox(
                    minX: Double(box.minX), minY: Double(box.minY),
                    maxX: Double(box.maxX), maxY: Double(box.maxY)),
                    let confidence = OCRGeometry.confidence(Double(candidate.confidence)) else { return nil }
                return OCRBlock(text: candidate.string,
                                confidence: confidence, bbox: bbox)
            }
            return OCRResult(status: blocks.isEmpty ? "empty" : "ok",
                             text: blocks.map(\.text).joined(separator: "\n"), blocks: blocks,
                             requestRevision: revision, languages: request.recognitionLanguages)
        } catch {
            // OCR is an index. A failed recognition never discards its canonical JPEG.
            return OCRResult(status: "failed", text: "", blocks: [], requestRevision: revision,
                             languages: request.recognitionLanguages, errorCode: "vision_request_failed")
        }
    }
}

enum ArchiveMemory {
    static func footprint() -> UInt64? {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size)
        let result = withUnsafeMutablePointer(to: &info) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        return result == KERN_SUCCESS ? info.phys_footprint : nil
    }
}
