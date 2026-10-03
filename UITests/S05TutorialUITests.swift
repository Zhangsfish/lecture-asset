import XCTest

final class S05TutorialUITests: XCTestCase {
    @MainActor
    func testFreshTutorialIsSkippableAndTeachesFiveScenesWithoutRequestingPhotos() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        XCTAssertTrue(app.buttons["tutorial-skip"].waitForExistence(timeout: 20))
        XCTAssertTrue(app.buttons["tutorial-skip"].isHittable)
        var page = 0
        for title in ["Press and drag to select", "Capture-time order", "Generate ZIP + PDF", "Save, then clean up", "Hand it to AI"] {
            page += 1
            XCTAssertEqual(app.staticTexts["tutorial-title"].label, title)
            XCTAssertEqual(app.otherElements["tutorial-page"].label, "\(page) / 5")
            XCTAssertEqual(app.buttons["tutorial-next"].label, page == 5 ? "Done" : "Next")
            if page == 2 {
                app.otherElements["tutorial-artwork"].swipeRight()
                XCTAssertEqual(app.staticTexts["tutorial-title"].label, "Press and drag to select")
                app.otherElements["tutorial-artwork"].swipeLeft()
                XCTAssertEqual(app.staticTexts["tutorial-title"].label, title)
                app.buttons["tutorial-previous"].tap()
                XCTAssertEqual(app.staticTexts["tutorial-title"].label, "Press and drag to select")
                app.buttons["tutorial-next"].tap()
            }
            // Capture the settled teaching scene, not its crossfade from the previous one.
            Thread.sleep(forTimeInterval: 4)
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "s05-b2-tutorial-\(title)"
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
        for _ in 0..<5 {
            if !app.buttons["tutorial-next"].isHittable { app.swipeUp() }
            XCTAssertTrue(app.buttons["tutorial-next"].isHittable)
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = "s05-b2-reduced-motion-large-text"
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

final class S05FirstSkipUITests: XCTestCase {
    @MainActor
    func testFreshFirstRunCanBeSkippedImmediatelyWithoutPhotosPrompt() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        XCTAssertTrue(app.buttons["tutorial-skip"].waitForExistence(timeout: 20))
        app.buttons["tutorial-skip"].tap()
        XCTAssertTrue(app.buttons["permission-allow"].waitForExistence(timeout: 5))
        XCTAssertFalse(XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch.exists)
        app.terminate(); app.launch()
        XCTAssertTrue(app.buttons["permission-allow"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["tutorial-skip"].exists)
    }
}
