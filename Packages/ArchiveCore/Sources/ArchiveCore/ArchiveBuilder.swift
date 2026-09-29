import CoreGraphics
import CryptoKit
import Foundation
import ImageIO
import UniformTypeIdentifiers
import ZIPFoundation

public struct ArchiveInputPage: Sendable {
    public let sourceURL: URL
    public let record: ArchivePage
    public init(sourceURL: URL, record: ArchivePage) { self.sourceURL = sourceURL; self.record = record }
}

public struct ArchiveOutput: Sendable {
    public let zipURL: URL
    public let pdfURL: URL
    public let zipSHA256: String
    public let pdfSHA256: String
    public let manifest: Manifest
    public let pdfLongEdge: Int
    public let pdfJPEGQuality: Double
}

public enum ArchiveFailure: Error, CustomStringConvertible {
    case invalid(String)
    public var description: String { if case let .invalid(message) = self { message } else { "archive failure" } }
}

/// File-backed build. Every loop iteration holds at most one decoded source image.
public enum ArchiveBuilder {
    public static let pdfLongEdge = 3000
    public static let pdfJPEGQuality = 0.90

    public static func build(pages: [ArchiveInputPage], archiveID: UUID, title: String,
                             jobCreatedAt: Date, destination: URL, schemaURL: URL,
                             progress: ((Int, Int) -> Void)? = nil) throws -> ArchiveOutput {
        guard (1...200).contains(pages.count), title.count <= 200 else { throw ArchiveFailure.invalid("page count/title") }
        let fm = FileManager.default
        try fm.createDirectory(at: destination, withIntermediateDirectories: true)
        let needed = pages.reduce(Int64(50_000_000)) { $0 + Int64($1.record.bytes) * 2 }
        let capacity = try destination.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            .volumeAvailableCapacityForImportantUsage
        guard let capacity, capacity > needed else { throw ArchiveFailure.invalid("insufficient device storage") }

        let records = pages.map(\.record)
        for (offset, input) in pages.enumerated() {
            guard input.record.number == offset + 1,
                  input.record.image == String(format: "slides/%04d.jpg", offset + 1),
                  input.record.selectionIndex >= 1 else { throw ArchiveFailure.invalid("frozen page order") }
            try verifyImage(input)
        }
        let rootName = "Lecture_\(safeDate(from: title))_\(archiveID.uuidString.prefix(8).lowercased())"
        let work = destination.appending(path: ".building-\(archiveID.uuidString)", directoryHint: .isDirectory)
        if fm.fileExists(atPath: work.path) { try fm.removeItem(at: work) }
        try fm.createDirectory(at: work, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: work) }

        let readmeURL = work.appending(path: "README.md")
        let lectureURL = work.appending(path: "lecture.md")
        try Data(MarkdownDocument.readme.utf8).write(to: readmeURL, options: .atomic)
        try Data(MarkdownDocument.lecture(title: title, pages: records).utf8).write(to: lectureURL, options: .atomic)
        var files = [try measuredFile(path: "README.md", url: readmeURL),
                     try measuredFile(path: "lecture.md", url: lectureURL)]
        for input in pages { files.append(try measuredFile(path: input.record.image, url: input.sourceURL)) }
        let manifest = Manifest(archiveId: archiveID, title: title, createdAt: ArchiveDate.iso(jobCreatedAt),
                                pages: records, files: files)
        let manifestData = try ArchiveJSON.encoder().encode(manifest)
        try SchemaValidator(schemaURL: schemaURL).validate(manifestData)
        try checkRelations(manifest)
        let manifestURL = work.appending(path: "manifest.json")
        try manifestData.write(to: manifestURL, options: .atomic)

        let zipTemp = work.appending(path: "archive.zip")
        let writer = try Archive(url: zipTemp, accessMode: .create)
        try writer.addEntry(with: "\(rootName)/README.md", fileURL: readmeURL, compressionMethod: .none)
        try writer.addEntry(with: "\(rootName)/lecture.md", fileURL: lectureURL, compressionMethod: .none)
        try writer.addEntry(with: "\(rootName)/manifest.json", fileURL: manifestURL, compressionMethod: .none)
        for (offset, input) in pages.enumerated() {
            try writer.addEntry(with: "\(rootName)/\(input.record.image)", fileURL: input.sourceURL,
                                compressionMethod: .none, bufferSize: 1_048_576)
            progress?(offset + 1, pages.count)
        }
        try ArchiveValidator.validateZIP(at: zipTemp, rootName: rootName, expected: manifest,
                                         schemaURL: schemaURL)

        let pdfTemp = work.appending(path: "archive.pdf")
        try CompanionPDF.write(pages: pages, to: pdfTemp)
        try CompanionPDF.validate(at: pdfTemp, pages: records)
        // The source may change while ZIP/PDF was being built. A changed canonical page invalidates ready.
        for input in pages { try verifyImage(input) }
        let zipName = rootName + "_AI.zip"
        let finalZIP = destination.appending(path: zipName)
        let finalPDF = destination.appending(path: rootName + ".pdf")
        if fm.fileExists(atPath: finalZIP.path) { try fm.removeItem(at: finalZIP) }
        if fm.fileExists(atPath: finalPDF.path) { try fm.removeItem(at: finalPDF) }
        try fm.moveItem(at: zipTemp, to: finalZIP)
        try fm.moveItem(at: pdfTemp, to: finalPDF)
        return ArchiveOutput(zipURL: finalZIP, pdfURL: finalPDF,
                             zipSHA256: try measure(finalZIP).hash, pdfSHA256: try measure(finalPDF).hash,
                             manifest: manifest, pdfLongEdge: pdfLongEdge, pdfJPEGQuality: pdfJPEGQuality)
    }

    private static func safeDate(from title: String) -> String {
        let date = title.replacingOccurrences(of: "Lecture ", with: "")
        return date.range(of: #"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"#, options: .regularExpression) != nil ? date : "unknown"
    }

    private static func measuredFile(path: String, url: URL) throws -> ArchiveFile {
        let value = try measure(url)
        return ArchiveFile(path: path, bytes: value.bytes, sha256: value.hash)
    }

    public static func measure(_ url: URL) throws -> (bytes: Int, hash: String) {
        let handle = try FileHandle(forReadingFrom: url)
        defer { try? handle.close() }
        var hasher = SHA256(); var bytes = 0
        while let data = try handle.read(upToCount: 1_048_576), !data.isEmpty {
            hasher.update(data: data); bytes += data.count
        }
        return (bytes, hasher.finalize().map { String(format: "%02x", $0) }.joined())
    }

    public static func verifyImage(_ input: ArchiveInputPage) throws {
        let values = try input.sourceURL.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey])
        guard values.isRegularFile == true, values.isSymbolicLink != true else {
            throw ArchiveFailure.invalid("canonical JPEG is not a regular file")
        }
        let measured = try measure(input.sourceURL)
        guard measured.bytes == input.record.bytes, measured.hash == input.record.sha256,
              let source = CGImageSourceCreateWithURL(input.sourceURL as CFURL, [kCGImageSourceShouldCache: false] as CFDictionary),
              CGImageSourceGetCount(source) == 1,
              let image = CGImageSourceCreateImageAtIndex(source, 0, nil),
              image.width == input.record.width, image.height == input.record.height else {
            throw ArchiveFailure.invalid("canonical JPEG integrity")
        }
    }

    public static func checkRelations(_ manifest: Manifest) throws {
        guard manifest.pageCount == manifest.pages.count, manifest.sourceCount == manifest.pages.count,
              manifest.files.count == manifest.pages.count + 2,
              manifest.files.map(\.path) == ["README.md", "lecture.md"] + manifest.pages.map(\.image) else {
            throw ArchiveFailure.invalid("manifest counts/files")
        }
        for (index, page) in manifest.pages.enumerated() {
            let file = manifest.files[index + 2]
            guard page.number == index + 1, page.image == String(format: "slides/%04d.jpg", index + 1),
                  page.bytes == file.bytes, page.sha256 == file.sha256,
                  page.captureTimeSource == (page.capturedAt == nil ? "unavailable" : "photokit") else {
                throw ArchiveFailure.invalid("manifest page relation")
            }
        }
    }
}

public enum ArchiveValidator {
    public static func validateZIP(at url: URL, rootName: String, expected: Manifest, schemaURL: URL) throws {
        let reader = try Archive(url: url, accessMode: .read)
        let expectedNames = ["README.md", "lecture.md", "manifest.json"] + expected.pages.map(\.image)
        let names = reader.map(\.path)
        guard names == expectedNames.map({ "\(rootName)/\($0)" }) else {
            throw ArchiveFailure.invalid("ZIP path whitelist/order")
        }
        let fileMap = Dictionary(uniqueKeysWithValues: expected.files.map { ($0.path, $0) })
        for entry in reader {
            guard entry.type == .file, !entry.path.contains(".."), !entry.path.contains("\\"),
                  entry.path.hasPrefix(rootName + "/") else { throw ArchiveFailure.invalid("ZIP unsafe entry") }
            let relative = String(entry.path.dropFirst(rootName.count + 1))
            var hash = SHA256(); var bytes = 0; var smallData = Data()
            _ = try reader.extract(entry, bufferSize: 1_048_576, skipCRC32: false) { chunk in
                hash.update(data: chunk); bytes += chunk.count
                if relative == "manifest.json" {
                    guard smallData.count + chunk.count <= 16_000_000 else { throw ArchiveFailure.invalid("manifest too large") }
                    smallData.append(chunk)
                }
            }
            let digest = hash.finalize().map { String(format: "%02x", $0) }.joined()
            if relative == "manifest.json" {
                try SchemaValidator(schemaURL: schemaURL).validate(smallData)
                let decoded = try JSONDecoder.manifestDecoder.decode(Manifest.self, from: smallData)
                try ArchiveBuilder.checkRelations(decoded)
                guard smallData == ArchiveJSON.encoder().encode(expected) else {
                    throw ArchiveFailure.invalid("ZIP manifest changed")
                }
            } else {
                guard let expectedFile = fileMap[relative], expectedFile.bytes == bytes,
                      expectedFile.sha256 == digest else { throw ArchiveFailure.invalid("ZIP content hash") }
            }
        }
        // The exact generated Markdown hash above binds all page headers and image links.
    }
}

private extension JSONDecoder {
    static var manifestDecoder: JSONDecoder {
        let decoder = JSONDecoder(); decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
