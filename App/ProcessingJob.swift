import CryptoKit
import Foundation
import ImageIO
import SelectionCore

enum JobPhase: String, Codable, Sendable {
    case processing
    case paused
    case failed
    case completed
}

enum PagePhase: String, Codable, Sendable {
    case pending
    case failed
    case completed
}

enum PageFailure: String, Codable, Sendable {
    case permissionLost
    case assetUnavailable
    case notDownloaded
    case degradedResult
    case photoKitFailed
    case sourceInvalid
    case dimensionChanged
    case jpegFailed
    case checkpointInvalid
}

struct JobPage: Codable, Identifiable, Sendable {
    var pageIndex: Int
    let assetIdentifier: String // Private ledger only. Never export into portable files or diagnostics.
    let capturedAt: Date?
    let selectionIndex: Int
    let isLivePhoto: Bool
    var phase: PagePhase = .pending
    var failure: PageFailure?
    var sourceStillBytes: Int?
    var width: Int?
    var height: Int?
    var jpegBytes: Int?
    var sha256: String?
    var memoryBytesPeakPage: UInt64?
    var memoryBytesAfterPage: UInt64?

    var id: Int { pageIndex }
    var filename: String { String(format: "%04d.jpg", pageIndex) }

    init(frozen: FrozenPage, isLivePhoto: Bool) {
        pageIndex = frozen.pageIndex
        assetIdentifier = frozen.localIdentifier
        capturedAt = frozen.capturedAt
        selectionIndex = frozen.selectionIndex
        self.isLivePhoto = isLivePhoto
    }
}

struct ProcessingJob: Codable, Identifiable, Sendable {
    let id: UUID
    let createdAt: Date
    var phase: JobPhase
    var pages: [JobPage]
    var sourcesDeleted: Bool? // Optional for checkpoints written before S03.

    var completedCount: Int { pages.filter { $0.phase == .completed }.count }
    var totalCount: Int { pages.count }
    var failedPage: JobPage? { pages.first { $0.phase == .failed } }
    var nextPage: JobPage? { pages.first { $0.phase == .pending } }

    init(pages: [JobPage]) {
        id = UUID()
        createdAt = Date()
        phase = .processing
        self.pages = pages
    }
}

enum JobStore {
    static func root() throws -> URL {
        let support = try FileManager.default.url(
            for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        let root = support.appending(path: "LectureAsset/jobs", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        return root
    }

    static func directory(for job: ProcessingJob) throws -> URL {
        try root().appending(path: job.id.uuidString, directoryHint: .isDirectory)
    }

    static func purge(_ job: ProcessingJob) throws {
        // The UUID directory is the entire private working copy for this one job.
        let directory = try directory(for: job)
        guard FileManager.default.fileExists(atPath: directory.path) else { return }
        try FileManager.default.removeItem(at: directory)
    }

    static func imageURL(for page: JobPage, in job: ProcessingJob) throws -> URL {
        try directory(for: job)
            .appending(path: "slides", directoryHint: .isDirectory)
            .appending(path: page.filename)
    }

    static func save(_ job: ProcessingJob) throws {
        let directory = try directory(for: job)
        try FileManager.default.createDirectory(
            at: directory.appending(path: "slides", directoryHint: .isDirectory),
            withIntermediateDirectories: true
        )
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .custom { date, encoder in
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            var value = encoder.singleValueContainer()
            try value.encode(formatter.string(from: date))
        }
        try encoder.encode(job).write(to: directory.appending(path: "job.json"), options: .atomic)
    }

    static func loadLatest() throws -> ProcessingJob? {
        let directories = try FileManager.default.contentsOfDirectory(
            at: root(), includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles]
        )
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let text = try decoder.singleValueContainer().decode(String.self)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            guard let date = formatter.date(from: text) else {
                throw DecodingError.dataCorruptedError(
                    in: try decoder.singleValueContainer(), debugDescription: "Invalid job date"
                )
            }
            return date
        }
        let jobs = try directories.compactMap { directory -> ProcessingJob? in
            let stateURL = directory.appending(path: "job.json")
            guard FileManager.default.fileExists(atPath: stateURL.path) else { return nil }
            return try decoder.decode(ProcessingJob.self, from: Data(contentsOf: stateURL))
        }
        return jobs.max { $0.createdAt < $1.createdAt }
    }

    static func verifyCompleted(_ page: JobPage, in job: ProcessingJob) throws -> Bool {
        guard page.phase == .completed,
              let width = page.width, let height = page.height,
              let bytes = page.jpegBytes, let sha256 = page.sha256 else { return false }
        let url = try imageURL(for: page, in: job)
        guard FileManager.default.fileExists(atPath: url.path),
              let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let actualWidth = properties[kCGImagePropertyPixelWidth] as? Int,
              let actualHeight = properties[kCGImagePropertyPixelHeight] as? Int,
              actualWidth == width, actualHeight == height else { return false }
        let measurement = try fileMeasurement(at: url)
        return measurement.bytes == bytes && measurement.sha256 == sha256
    }

    static func fileMeasurement(at url: URL) throws -> (bytes: Int, sha256: String) {
        let handle = try FileHandle(forReadingFrom: url)
        defer { try? handle.close() }
        var hash = SHA256()
        var bytes = 0
        while let chunk = try handle.read(upToCount: 1_048_576), !chunk.isEmpty {
            hash.update(data: chunk)
            bytes += chunk.count
        }
        return (bytes, hash.finalize().map { String(format: "%02x", $0) }.joined())
    }

    static func outputInventory(in job: ProcessingJob) throws -> (jpegCount: Int, motionAudioCount: Int) {
        let root = try directory(for: job)
        guard let files = FileManager.default.enumerator(at: root, includingPropertiesForKeys: nil) else {
            throw CocoaError(.fileReadUnknown)
        }
        var jpegCount = 0
        var motionAudioCount = 0
        let motionAudioExtensions: Set<String> = ["mov", "mp4", "m4v", "m4a", "caf", "wav", "aac"]
        for case let url as URL in files {
            let ext = url.pathExtension.lowercased()
            if ext == "jpg" { jpegCount += 1 }
            if motionAudioExtensions.contains(ext) { motionAudioCount += 1 }
        }
        return (jpegCount, motionAudioCount)
    }
}
