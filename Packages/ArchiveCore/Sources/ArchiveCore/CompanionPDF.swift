import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers
import Darwin.Mach

public enum CompanionPDF {
    public static func write(pages: [ArchiveInputPage], to url: URL,
                             memorySample: ((Int, UInt64, UInt64) -> Void)? = nil) throws {
        guard let context = CGContext(url as CFURL, mediaBox: nil, nil) else {
            throw ArchiveFailure.invalid("PDF context")
        }
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
                var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                let temporary = url.deletingLastPathComponent().appending(path: ".page-\(input.record.number).jpg")
                defer { try? FileManager.default.removeItem(at: temporary) }
                try writeBrowseJPEG(source: input.sourceURL, maxPixelSize: rasterLongEdge, to: temporary)
                sample()
                guard let source = CGImageSourceCreateWithURL(temporary as CFURL, [kCGImageSourceShouldCache: false] as CFDictionary),
                      let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
                    throw ArchiveFailure.invalid("PDF browse JPEG")
                }
                context.beginPDFPage([kCGPDFContextMediaBox: Data(bytes: &mediaBox, count: MemoryLayout<CGRect>.size)] as CFDictionary)
                context.interpolationQuality = .high
                context.draw(image, in: mediaBox)
                sample()
                context.endPDFPage()
                sample()
                let after = footprint() ?? 0
                memorySample?(input.record.number, after, max(pagePeak, after))
            }
        }
        context.closePDF()
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
