@preconcurrency import Photos
import CoreImage
import Foundation
import ImageIO
import UniformTypeIdentifiers
import Darwin.Mach

struct PageOutput: Sendable {
    let sourceStillBytes: Int
    let width: Int
    let height: Int
    let jpegBytes: Int
    let sha256: String
    let memoryBytesPeakPage: UInt64?
    let memoryBytesAfterPage: UInt64?
}

struct PageProcessingError: Error, Sendable {
    let code: PageFailure
}

/// One call is awaited before the next page starts. No full-size image is cached across pages.
actor CanonicalStillPipeline {
    func process(_ page: JobPage, in job: ProcessingJob) async throws -> PageOutput {
        let encoded = try await encode(page, in: job)
        return PageOutput(
            sourceStillBytes: encoded.sourceStillBytes,
            width: encoded.width,
            height: encoded.height,
            jpegBytes: encoded.jpegBytes,
            sha256: encoded.sha256,
            memoryBytesPeakPage: encoded.memoryBytesPeakPage,
            memoryBytesAfterPage: Self.currentFootprintBytes()
        )
    }

    private func encode(_ page: JobPage, in job: ProcessingJob) async throws -> PageOutput {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized else {
            throw PageProcessingError(code: .permissionLost)
        }
        let fetch = PHAsset.fetchAssets(withLocalIdentifiers: [page.assetIdentifier], options: nil)
        guard let asset = fetch.firstObject, asset.mediaType == .image else {
            throw PageProcessingError(code: .assetUnavailable)
        }

        let (data, orientation) = try await Self.currentStill(for: asset)
        let destinationURL = try JobStore.imageURL(for: page, in: job)
        return try autoreleasepool {
            try Self.writeJPEG(data: data, orientation: orientation, to: destinationURL)
        }
    }

    private static func currentStill(for asset: PHAsset) async throws -> (Data, CGImagePropertyOrientation) {
        let options = PHImageRequestOptions()
        options.version = .current // Photos renders the user's current edits.
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = false
        options.isSynchronous = false

        return try await withCheckedThrowingContinuation { continuation in
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) {
                data, _, orientation, info in
                if (info?[PHImageCancelledKey] as? NSNumber)?.boolValue == true {
                    continuation.resume(throwing: PageProcessingError(code: .photoKitFailed))
                } else if (info?[PHImageResultIsInCloudKey] as? NSNumber)?.boolValue == true {
                    continuation.resume(throwing: PageProcessingError(code: .notDownloaded))
                } else if info?[PHImageErrorKey] != nil {
                    continuation.resume(throwing: PageProcessingError(code: .photoKitFailed))
                } else if (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue == true {
                    continuation.resume(throwing: PageProcessingError(code: .degradedResult))
                } else if let data, !data.isEmpty {
                    continuation.resume(returning: (data, orientation))
                } else {
                    continuation.resume(throwing: PageProcessingError(code: .sourceInvalid))
                }
            }
        }
    }

    private static func writeJPEG(
        data: Data, orientation: CGImagePropertyOrientation, to finalURL: URL
    ) throws -> PageOutput {
        guard let source = CGImageSourceCreateWithData(data as CFData, [
            kCGImageSourceShouldCache: false
        ] as CFDictionary) else {
            throw PageProcessingError(code: .sourceInvalid)
        }
        let primaryIndex = CGImageSourceGetPrimaryImageIndex(source)
        guard primaryIndex < CGImageSourceGetCount(source),
              let raw = CGImageSourceCreateImageAtIndex(source, primaryIndex, [
                kCGImageSourceShouldCacheImmediately: true
              ] as CFDictionary) else {
            throw PageProcessingError(code: .sourceInvalid)
        }
        let footprintAfterDecode = currentFootprintBytes() ?? 0

        let swapped = [CGImagePropertyOrientation.left, .leftMirrored, .right, .rightMirrored]
            .contains(orientation)
        let expectedWidth = swapped ? raw.height : raw.width
        let expectedHeight = swapped ? raw.width : raw.height
        let oriented = CIImage(cgImage: raw).oriented(orientation)
        let extent = oriented.extent.integral
        guard Int(extent.width) == expectedWidth, Int(extent.height) == expectedHeight,
              expectedWidth > 0, expectedHeight > 0,
              let sRGB = CGColorSpace(name: CGColorSpace.sRGB) else {
            throw PageProcessingError(code: .dimensionChanged)
        }

        // JPEG has no alpha: composite transparent source pixels onto white at native dimensions.
        let white = CIImage(color: CIColor(red: 1, green: 1, blue: 1))
            .cropped(to: extent)
        let opaque = oriented.composited(over: white)
        let context = CIContext(options: [.cacheIntermediates: false])
        guard let upright = context.createCGImage(
            opaque, from: extent, format: .RGBA8, colorSpace: sRGB
        ), upright.width == expectedWidth, upright.height == expectedHeight else {
            throw PageProcessingError(code: .dimensionChanged)
        }
        let footprintAfterRender = currentFootprintBytes() ?? 0

        let temporaryURL = finalURL.deletingLastPathComponent()
            .appending(path: ".\(UUID().uuidString).jpg.tmp")
        defer { try? FileManager.default.removeItem(at: temporaryURL) }
        guard let destination = CGImageDestinationCreateWithURL(
            temporaryURL as CFURL, UTType.jpeg.identifier as CFString, 1, nil
        ) else {
            throw PageProcessingError(code: .jpegFailed)
        }
        CGImageDestinationAddImage(destination, upright, [
            kCGImageDestinationLossyCompressionQuality: 0.90
        ] as CFDictionary)
        guard CGImageDestinationFinalize(destination),
              let checkSource = CGImageSourceCreateWithURL(temporaryURL as CFURL, nil),
              let checkImage = CGImageSourceCreateImageAtIndex(checkSource, 0, nil),
              checkImage.width == expectedWidth, checkImage.height == expectedHeight,
              checkImage.colorSpace?.name == CGColorSpace.sRGB else {
            throw PageProcessingError(code: .jpegFailed)
        }
        let footprintAfterWrite = currentFootprintBytes() ?? 0

        let measured = try JobStore.fileMeasurement(at: temporaryURL)
        // A previously interrupted attempt may have left an uncheckpointed file.
        if FileManager.default.fileExists(atPath: finalURL.path) {
            try FileManager.default.removeItem(at: finalURL)
        }
        try FileManager.default.moveItem(at: temporaryURL, to: finalURL)
        return PageOutput(
            sourceStillBytes: data.count,
            width: expectedWidth,
            height: expectedHeight,
            jpegBytes: measured.bytes,
            sha256: measured.sha256,
            memoryBytesPeakPage: max(footprintAfterDecode, footprintAfterRender, footprintAfterWrite),
            memoryBytesAfterPage: nil
        )
    }

    private static func currentFootprintBytes() -> UInt64? {
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
