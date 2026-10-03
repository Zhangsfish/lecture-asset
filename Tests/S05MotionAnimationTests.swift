import AVFoundation
import SwiftUI
import XCTest
@testable import Lecture_Asset

/// A deterministic movie of production SwiftUI drawings on iOS Simulator.
/// Only synthetic vectors/text are rendered. No app debug switches or Photos.
final class S05MotionAnimationTests: XCTestCase {
    @MainActor
    func testRenderFiveNativeMicroShots() async throws {
        let url = FileManager.default.temporaryDirectory.appending(path: "tutorial-five-scenes.mp4")
        try? FileManager.default.removeItem(at: url)
        defer { try? FileManager.default.removeItem(at: url) }
        let writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: 780, AVVideoHeightKey: 1060
        ])
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input,
            sourcePixelBufferAttributes: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
                                         kCVPixelBufferWidthKey as String: 780, kCVPixelBufferHeightKey as String: 1060])
        writer.add(input)
        XCTAssertTrue(writer.startWriting())
        writer.startSession(atSourceTime: .zero)
        let fps = 20
        let framesPerShot = Int(TutorialArtwork.duration * Double(fps)) + 10
        var frame = 0
        for scene in 0..<5 {
            for localFrame in 0..<framesPerShot {
                var readyAttempts = 0
                while !input.isReadyForMoreMediaData {
                    try await Task.sleep(for: .milliseconds(10))
                    readyAttempts += 1
                    guard readyAttempts < 1000 else { throw RenderError.writerTimedOut }
                }
                let time = min(TutorialArtwork.duration, Double(localFrame) / Double(fps))
                let buffer: CVPixelBuffer = try autoreleasepool {
                    let view = VStack(spacing: 24) {
                        Text(LocalizedStringKey(TutorialView.titles[scene])).font(.title2.bold())
                        TutorialArtwork(scene: scene, time: time)
                        Text("\(scene + 1) / 5").font(.caption)
                    }.frame(width: 390, height: 530).background(Color(.systemBackground))
                        .environment(\.locale, Locale(identifier: "zh-Hans"))
                        .environment(\.colorScheme, .light)
                    let renderer = ImageRenderer(content: view)
                    renderer.scale = 2
                    let image = try XCTUnwrap(renderer.uiImage?.cgImage)
                    var pixel: CVPixelBuffer?
                    let status = CVPixelBufferCreate(kCFAllocatorDefault, 780, 1060,
                        kCVPixelFormatType_32ARGB, [kCVPixelBufferCGImageCompatibilityKey: true,
                                                 kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary, &pixel)
                    XCTAssertEqual(status, kCVReturnSuccess)
                    let result = try XCTUnwrap(pixel)
                    CVPixelBufferLockBaseAddress(result, [])
                    defer { CVPixelBufferUnlockBaseAddress(result, []) }
                    let context = try XCTUnwrap(CGContext(data: CVPixelBufferGetBaseAddress(result),
                        width: 780, height: 1060, bitsPerComponent: 8,
                        bytesPerRow: CVPixelBufferGetBytesPerRow(result), space: CGColorSpaceCreateDeviceRGB(),
                        bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue))
                    context.draw(image, in: CGRect(x: 0, y: 0, width: 780, height: 1060))
                    return result
                }
                XCTAssertTrue(adaptor.append(buffer, withPresentationTime: CMTime(value: Int64(frame), timescale: Int32(fps))))
                frame += 1
            }
        }
        input.markAsFinished()
        await writer.finishWriting()
        XCTAssertEqual(writer.status, .completed)
        let attachment = XCTAttachment(contentsOfFile: url)
        attachment.name = "native-five-scene-animation"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private enum RenderError: Error { case writerTimedOut }
}
