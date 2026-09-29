import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers
import Darwin.Mach

public enum CompanionPDF {
    public static func write(pages: [ArchiveInputPage], to url: URL,
                             memorySample: ((Int, UInt64, UInt64) -> Void)? = nil) throws {
        // Write image streams directly into the PDF file. A Core Graphics PDF context
        // retained document-level image data until close, growing with the page count.
        // The JPEG for one page is the only temporary file alive during this loop.
        let writer = try StreamingPDFWriter(url: url, pageCount: pages.count)
        for input in pages {
            try autoreleasepool {
                var pagePeak = footprint() ?? 0
                func sample() { pagePeak = max(pagePeak, footprint() ?? 0) }
                let width = input.record.width
                let height = input.record.height
                let longEdge = max(width, height)
                // Preserve the original width of very tall screenshots; a 3000 px long edge
                // would otherwise reduce a 1179 x 25194 image to about 140 px wide.
                let rasterLongEdge = Double(height) / Double(width) > 3
                    ? longEdge : min(longEdge, ArchiveBuilder.pdfLongEdge)
                let pageLongEdge = min(longEdge, ArchiveBuilder.pdfLongEdge)
                let pageWidth = CGFloat(width) * CGFloat(pageLongEdge) / CGFloat(longEdge)
                let pageHeight = CGFloat(height) * CGFloat(pageLongEdge) / CGFloat(longEdge)
                let temporary = url.deletingLastPathComponent().appending(path: ".page-\(input.record.number).jpg")
                defer { try? FileManager.default.removeItem(at: temporary) }
                try writeBrowseJPEG(source: input.sourceURL, maxPixelSize: rasterLongEdge, to: temporary)
                sample()
                guard let source = CGImageSourceCreateWithURL(temporary as CFURL, [kCGImageSourceShouldCache: false] as CFDictionary),
                      let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
                      let rasterWidth = properties[kCGImagePropertyPixelWidth] as? Int,
                      let rasterHeight = properties[kCGImagePropertyPixelHeight] as? Int,
                      rasterWidth > 0, rasterHeight > 0 else {
                    throw ArchiveFailure.invalid("PDF browse JPEG")
                }
                try writer.append(number: input.record.number, jpegURL: temporary,
                                  rasterWidth: rasterWidth, rasterHeight: rasterHeight,
                                  pageWidth: pageWidth, pageHeight: pageHeight)
                sample()
                let after = footprint() ?? 0
                memorySample?(input.record.number, after, max(pagePeak, after))
            }
        }
        try writer.finish()
    }

    private static func footprint() -> UInt64? {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size)
        let result = withUnsafeMutablePointer(to: &info) { pointer in
            pointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        return result == KERN_SUCCESS ? info.phys_footprint : nil
    }

    private static func writeBrowseJPEG(source url: URL, maxPixelSize: Int, to target: URL) throws {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, [kCGImageSourceShouldCache: false] as CFDictionary),
              let thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: false,
                kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
                kCGImageSourceShouldCacheImmediately: true
              ] as CFDictionary),
              let destination = CGImageDestinationCreateWithURL(target as CFURL, UTType.jpeg.identifier as CFString, 1, nil) else {
            throw ArchiveFailure.invalid("PDF thumbnail")
        }
        CGImageDestinationAddImage(destination, thumbnail, [kCGImageDestinationLossyCompressionQuality: ArchiveBuilder.pdfJPEGQuality] as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { throw ArchiveFailure.invalid("PDF JPEG encode") }
    }

    public static func validate(at url: URL, pages: [ArchiveInputPage]) throws {
        guard let document = CGPDFDocument(url as CFURL), document.numberOfPages == pages.count else {
            throw ArchiveFailure.invalid("PDF page count")
        }
        for (index, input) in pages.enumerated() {
            let record = input.record
            guard let page = document.page(at: index + 1) else { throw ArchiveFailure.invalid("PDF missing page") }
            let rect = page.getBoxRect(.mediaBox)
            let ratio = Double(record.width) / Double(record.height)
            guard rect.width > 0, rect.height > 0,
                  abs(Double(rect.width / rect.height) - ratio) < 0.001 else {
                throw ArchiveFailure.invalid("PDF page box/order")
            }
            // At least one image XObject is required. The renderer never writes text.
            guard page.dictionary != nil else { throw ArchiveFailure.invalid("PDF page dictionary") }
            try autoreleasepool {
                let expected = try thumbnailOfJPEG(at: input.sourceURL)
                let actual = try thumbnailOfPDF(page, mediaBox: rect)
                let meanError = zip(expected, actual).reduce(0) { $0 + abs(Int($1.0) - Int($1.1)) }
                    / max(1, expected.count)
                guard meanError <= 12 else { throw ArchiveFailure.invalid("PDF page image/order") }
            }
        }
    }

    private static func bitmap(_ draw: (CGContext) throws -> Void) throws -> [UInt8] {
        let side = 96
        var pixels = [UInt8](repeating: 255, count: side * side * 4)
        try pixels.withUnsafeMutableBytes { buffer in
            guard let context = CGContext(data: buffer.baseAddress, width: side, height: side,
                                          bitsPerComponent: 8, bytesPerRow: side * 4,
                                          space: CGColorSpace(name: CGColorSpace.sRGB)!,
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue |
                                              CGBitmapInfo.byteOrder32Big.rawValue) else {
                throw ArchiveFailure.invalid("PDF verification bitmap")
            }
            context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
            context.fill(CGRect(x: 0, y: 0, width: side, height: side))
            try draw(context)
        }
        return pixels
    }

    private static func thumbnailOfJPEG(at url: URL) throws -> [UInt8] {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, [kCGImageSourceShouldCache: false] as CFDictionary),
              let image = CGImageSourceCreateThumbnailAtIndex(source, 0, [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 96
              ] as CFDictionary) else { throw ArchiveFailure.invalid("PDF source thumbnail") }
        return try bitmap { context in
            context.interpolationQuality = .high
            context.draw(image, in: CGRect(x: 0, y: 0, width: 96, height: 96))
        }
    }

    private static func thumbnailOfPDF(_ page: CGPDFPage, mediaBox: CGRect) throws -> [UInt8] {
        try bitmap { context in
            context.interpolationQuality = .high
            context.scaleBy(x: 96 / mediaBox.width, y: 96 / mediaBox.height)
            context.drawPDFPage(page)
        }
    }
}

/// Minimal PDF 1.4 writer for one RGB JPEG XObject per page. It streams JPEG
/// bytes from disk and keeps only object offsets in memory (O(page count)).
private final class StreamingPDFWriter {
    private let output: FileHandle
    private let pageCount: Int
    private var nextPage = 1
    private var offsets: [UInt64]
    private var finished = false

    init(url: URL, pageCount: Int) throws {
        guard FileManager.default.createFile(atPath: url.path, contents: nil) else {
            throw ArchiveFailure.invalid("PDF output file")
        }
        output = try FileHandle(forWritingTo: url)
        self.pageCount = pageCount
        offsets = [UInt64](repeating: 0, count: 3 + 3 * pageCount)
        try write("%PDF-1.4\n")
        try output.write(contentsOf: Data([0x25, 0xE2, 0xE3, 0xCF, 0xD3, 0x0A]))
        try object(1, "<< /Type /Catalog /Pages 2 0 R >>")
        let children = (0..<pageCount).map { "\(3 + 3 * $0) 0 R" }.joined(separator: " ")
        try object(2, "<< /Type /Pages /Kids [\(children)] /Count \(pageCount) >>")
    }

    deinit { try? output.close() }

    func append(number: Int, jpegURL: URL, rasterWidth: Int, rasterHeight: Int,
                pageWidth: CGFloat, pageHeight: CGFloat) throws {
        guard number == nextPage, rasterWidth > 0, rasterHeight > 0,
              pageWidth > 0, pageHeight > 0 else {
            throw ArchiveFailure.invalid("PDF sequential page")
        }
        let pageID = 3 + 3 * (number - 1)
        let contentID = pageID + 1
        let imageID = pageID + 2
        let pageW = Double(pageWidth).description
        let pageH = Double(pageHeight).description
        try object(pageID, "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 \(pageW) \(pageH)] " +
                   "/Resources << /XObject << /Im0 \(imageID) 0 R >> >> /Contents \(contentID) 0 R >>")
        let drawing = "q\n\(pageW) 0 0 \(pageH) 0 0 cm\n/Im0 Do\nQ\n"
        try streamObject(contentID, dictionary: "", bytes: Data(drawing.utf8))

        let attributes = try FileManager.default.attributesOfItem(atPath: jpegURL.path)
        guard let length = (attributes[.size] as? NSNumber)?.intValue, length > 0 else {
            throw ArchiveFailure.invalid("PDF JPEG size")
        }
        let dictionary = "/Type /XObject /Subtype /Image /Width \(rasterWidth) " +
            "/Height \(rasterHeight) /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /DCTDecode"
        try beginObject(imageID)
        try write("<< \(dictionary) /Length \(length) >>\nstream\n")
        let source = try FileHandle(forReadingFrom: jpegURL)
        defer { try? source.close() }
        var copied = 0
        while let chunk = try source.read(upToCount: 1_048_576), !chunk.isEmpty {
            copied += chunk.count
            try output.write(contentsOf: chunk)
        }
        guard copied == length else { throw ArchiveFailure.invalid("PDF JPEG changed during write") }
        try write("\nendstream\nendobj\n")
        nextPage += 1
    }

    func finish() throws {
        guard nextPage == pageCount + 1, !finished else {
            throw ArchiveFailure.invalid("PDF incomplete page set")
        }
        let xref = output.offsetInFile
        try write("xref\n0 \(offsets.count)\n0000000000 65535 f \n")
        for offset in offsets.dropFirst() {
            let digits = String(offset)
            guard digits.count <= 10, offset > 0 else { throw ArchiveFailure.invalid("PDF xref offset") }
            try write(String(repeating: "0", count: 10 - digits.count) + digits + " 00000 n \n")
        }
        try write("trailer\n<< /Size \(offsets.count) /Root 1 0 R >>\n" +
                  "startxref\n\(xref)\n%%EOF\n")
        try output.close()
        finished = true
    }

    private func beginObject(_ number: Int) throws {
        offsets[number] = output.offsetInFile
        try write("\(number) 0 obj\n")
    }

    private func object(_ number: Int, _ body: String) throws {
        try beginObject(number)
        try write("\(body)\nendobj\n")
    }

    private func streamObject(_ number: Int, dictionary: String, bytes: Data) throws {
        try beginObject(number)
        try write("<< \(dictionary) /Length \(bytes.count) >>\nstream\n")
        try output.write(contentsOf: bytes)
        try write("endstream\nendobj\n")
    }

    private func write(_ string: String) throws {
        try output.write(contentsOf: Data(string.utf8))
    }
}
