import XCTest

final class S03ExportUITests: XCTestCase {
    @MainActor
    func testReadyArchiveShowsSeparateSharesAndKeepsDeleteLockedAcrossRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)", "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        let phase = app.staticTexts["archive-phase"]
        XCTAssertTrue(phase.waitForExistence(timeout: 30))
        XCTAssertEqual(phase.label, "Files ready")
        XCTAssertTrue(app.buttons["export-share-zip"].exists)
        XCTAssertEqual(app.buttons["export-share-zip"].label, "Save AI ZIP")
        XCTAssertTrue(app.buttons["export-share-pdf"].exists)
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
        XCTAssertFalse(app.buttons["export-confirm-saved"].exists)
        let discard = app.buttons["export-discard-work"]
        if !discard.isHittable { app.swipeUp() }
        XCTAssertTrue(discard.isHittable, "App-only cleanup must be visible without opening a disclosure")
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "s05-b-ready-visible-cleanup-large-text"
        screenshot.lifetime = .keepAlways
        add(screenshot)
        discard.tap()
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@",
            "cannot be recovered from the App")).firstMatch.waitForExistence(timeout: 5))
        // Compact action sheets expose Cancel; a native popover dismisses outside.
        if app.buttons["Cancel"].exists {
            app.buttons["Cancel"].tap()
        } else {
            app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.98)).tap()
        }
        XCTAssertFalse(app.buttons["Discard App files only"].exists)
        XCTAssertTrue(app.buttons["export-share-zip"].exists)
        app.buttons["about-open"].tap()
        app.buttons["tutorial-replay"].tap()
        XCTAssertTrue(app.buttons["tutorial-skip"].waitForExistence(timeout: 5))
        app.buttons["tutorial-skip"].tap()
        app.buttons["about-close"].tap()
        XCTAssertTrue(app.staticTexts["archive-phase"].exists, "Replay must preserve the retained ready job")

        app.terminate()
        app.launch()
        let restored = app.staticTexts["archive-phase"]
        XCTAssertTrue(restored.waitForExistence(timeout: 30))
        XCTAssertEqual(restored.label, "Files ready")
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
    }
}
