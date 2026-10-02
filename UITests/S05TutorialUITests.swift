import XCTest

final class S05TutorialUITests: XCTestCase {
    @MainActor
    func testFreshTutorialIsSkippableAndTeachesFourScenesWithoutRequestingPhotos() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        XCTAssertTrue(app.buttons["tutorial-skip"].waitForExistence(timeout: 20))
        XCTAssertTrue(app.buttons["tutorial-skip"].isHittable)
        for title in ["Sweep to select", "Capture-time order", "Generate ZIP + PDF", "Save, then clean up"] {
            XCTAssertEqual(app.staticTexts["tutorial-title"].label, title)
            // Capture the settled teaching scene, not its crossfade from the previous one.
            _ = XCTWaiter.wait(for: [], timeout: 4)
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "s05-b-tutorial-\(title)"
            screenshot.lifetime = .keepAlways
            add(screenshot)
            XCTAssertFalse(XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch.exists)
            app.buttons["tutorial-next"].tap()
        }
        XCTAssertTrue(app.buttons["permission-allow"].waitForExistence(timeout: 5))
        app.buttons["about-open"].tap()
        app.buttons["tutorial-replay"].tap()
        XCTAssertTrue(app.buttons["tutorial-skip"].waitForExistence(timeout: 5))
        app.buttons["tutorial-skip"].tap()
        XCTAssertTrue(app.buttons["about-copy-email"].waitForExistence(timeout: 5))
        app.buttons["about-copy-email"].tap()
        XCTAssertEqual(app.buttons["about-copy-email"].label, "Email copied")
        XCTAssertTrue(app.buttons["about-email"].exists)
        XCTAssertTrue(app.buttons["about-homepage"].exists)
        app.buttons["about-close"].tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.buttons["permission-allow"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["tutorial-skip"].exists, "Tutorial must never be forced on relaunch")
    }
}

final class S05ReducedMotionUITests: XCTestCase {
    @MainActor
    func testLargeTextAndReducedMotionReplayRemainUsableWithoutPhotosAccess() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)", "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        XCTAssertTrue(app.buttons["Open Settings"].waitForExistence(timeout: 15))
        app.buttons["about-open"].tap()
        app.buttons["tutorial-replay"].tap()
        XCTAssertTrue(app.otherElements["tutorial-static"].waitForExistence(timeout: 5))
        for _ in 0..<4 {
            if !app.buttons["tutorial-next"].isHittable { app.swipeUp() }
            XCTAssertTrue(app.buttons["tutorial-next"].isHittable)
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "s05-b-reduced-motion-large-text"
            screenshot.lifetime = .keepAlways
            add(screenshot)
            app.buttons["tutorial-next"].tap()
        }
        XCTAssertTrue(app.buttons["about-close"].waitForExistence(timeout: 5))
        app.buttons["about-close"].tap()
        XCTAssertTrue(app.buttons["Open Settings"].exists)
        XCTAssertFalse(app.collectionViews["photo-grid"].exists)
    }
}
