import SwiftUI
import XCTest
@testable import Lecture_Asset

/// Production vector artwork rendered by SwiftUI on an actual iOS Simulator.
/// Fixed time is a constructor input, not a production launch/debug backdoor.
final class S05MotionStoryboardTests: XCTestCase {
    @MainActor
    func testFiveSettledNativeStoryboards() throws {
        XCTAssertEqual(TutorialView.titles.count, 5)
        for scene in 0..<5 {
            let view = VStack(spacing: 24) {
                Text(LocalizedStringKey(TutorialView.titles[scene])).font(.title2.bold())
                TutorialArtwork(scene: scene, time: TutorialArtwork.duration)
                Text("\(scene + 1) / 5").font(.caption)
            }.frame(width: 390, height: 530).background(Color(.systemBackground))
                .environment(\.locale, Locale(identifier: "zh-Hans"))
                .environment(\.colorScheme, .light)
            let renderer = ImageRenderer(content: view)
            renderer.scale = 3
            let image = try XCTUnwrap(renderer.uiImage)
            let attachment = XCTAttachment(image: image)
            attachment.name = "storyboard-scene-\(scene + 1)"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    @MainActor
    func testAnticipationActionAndSettleEvidence() throws {
        for scene in 0..<5 {
            for time in [0.4, 0.6, 1.0, 1.6, 2.1, 3.0] {
                let renderer = ImageRenderer(content: TutorialArtwork(scene: scene, time: time)
                    .background(Color(.systemBackground))
                    .environment(\.locale, Locale(identifier: "zh-Hans"))
                    .environment(\.colorScheme, .light))
                renderer.scale = 2
                let attachment = XCTAttachment(image: try XCTUnwrap(renderer.uiImage))
                attachment.name = "phase-scene-\(scene + 1)-t\(time)"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
        }
    }
}
