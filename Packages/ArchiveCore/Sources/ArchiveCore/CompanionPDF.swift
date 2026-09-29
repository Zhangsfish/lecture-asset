import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

public enum CompanionPDF {
    public static func write(pages: [ArchiveInputPage], to url: URL) throws {
        guard let context = CGContext(url as CFURL, mediaBox: nil, nil) else {
            throw ArchiveFailure.invalid("PDF context")
        }
        for input in pages {
            try autoreleasepool {
                let width = input.record.width
                let height = input.record.height
                let longEdge = max(width, height)
                // Preserve the original width of very tall screenshots; a 3000 px long edge
                // would otherwise reduce a 1179 x 25194 image to about 140 px wide.
                let target = Double(height) / Double(width) > 3
                    ? longEdge : min(longEdge, ArchiveBuilder.pdfLongEdge)
                let pageWidth = CGFloat(width) * CGFloat(target) / CGFloat(longEdge)
                let pageHeight = CGFloat(height) * CGFloat(target) / CGFloat(longEdge)
                var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                let temporary = url.deletingLastPathComponent().appending(path: ".page-\(input.record.number).jpg")
                defer { try? FileManager.default.removeItem(at: temporary) }
                try writeBrowseJPEG(source: input.sourceURL, maxPixelSize: target, to: temporary)
                guard let source = CGImageSourceCreateWithURL(temporary as CFURL, [kCGImageSourceShouldCache: false] as CFDictionary),
                      let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
                    throw ArchiveFailure.invalid("PDF browse JPEG")
                }
                context.beginPDFPage([kCGPDFContextMediaBox: Data(bytes: &mediaBox, count: MemoryLayout<CGRect>.size)] as CFDictionary)
                context.interpolationQuality = .high
                context.draw(image, in: mediaBox)
                context.endPDFPage()
            }
        }
        context.closePDF()
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

    public static func validate(at url: URL, pages: [ArchivePage]) throws {
        guard let document = CGPDFDocument(url as CFURL), document.numberOfPages == pages.count else {
            throw ArchiveFailure.invalid("PDF page count")
        }
        for (index, record) in pages.enumerated() {
            guard let page = document.page(at: index + 1) else { throw ArchiveFailure.invalid("PDF missing page") }
            let rect = page.getBoxRect(.mediaBox)
            let ratio = Double(record.width) / Double(record.height)
            guard rect.width > 0, rect.height > 0,
                  abs(Double(rect.width / rect.height) - ratio) < 0.001 else {
                throw ArchiveFailure.invalid("PDF page box/order")
            }
            // At least one image XObject is required. The renderer never writes text.
            guard page.dictionary != nil else { throw ArchiveFailure.invalid("PDF page dictionary") }
        }
    }
}
