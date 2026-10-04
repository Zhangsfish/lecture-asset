import XCTest

/// Release UI captures on a fresh simulator, exclusively with fictional fixtures.
/// No sharing completion, save confirmation, or destructive action is performed.
final class S05StoreScreenshotsUITests: XCTestCase {
    @MainActor
    func testEnglishStoreScreensOnFictionalSlides() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
        if app.buttons["tutorial-skip"].waitForExistence(timeout: 15) {
            app.buttons["tutorial-skip"].tap()
        }
        XCTAssertTrue(app.buttons["permission-allow"].waitForExistence(timeout: 20))
        app.buttons["permission-allow"].tap()
        let alert = XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 20))
        let full = alert.buttons.matching(NSPredicate(
            format: "label CONTAINS[c] %@ OR label CONTAINS[c] %@", "Full Access", "All Photos"
        )).firstMatch
        XCTAssertTrue(full.exists)
        full.tap()
        XCTAssertTrue(app.cells["photo-cell-0"].waitForExistence(timeout: 30))
        for index in 0..<12 { app.cells["photo-cell-\(index)"].tap() }
        keep(app, "selection")
        app.buttons["selection-confirm"].tap()
        XCTAssertTrue(app.buttons["processing-start"].waitForExistence(timeout: 15))
        keep(app, "review")
        app.buttons["processing-start"].tap()
        XCTAssertTrue(app.buttons["archive-start"].waitForExistence(timeout: 120))
        keep(app, "prepared")
        app.buttons["archive-start"].tap()
        XCTAssertTrue(app.buttons["export-share-zip"].waitForExistence(timeout: 180))
        XCTAssertTrue(app.buttons["export-discard-work"].exists)
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
        keep(app, "ready")
        XCTAssertTrue(app.buttons["View PDF"].exists)
        app.buttons["View PDF"].tap()
        XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 15))
        Thread.sleep(forTimeInterval: 3)
        keep(app, "pdf")
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons["export-share-zip"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
    }

    @MainActor
    private func keep(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "store-en-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
