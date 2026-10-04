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
        Thread.sleep(forTimeInterval: 2)
        keep(app, "setup")
        let allow = app.buttons["permission-allow"]
        if allow.waitForExistence(timeout: 10) {
            allow.tap()
            Thread.sleep(forTimeInterval: 2)
            keep(app, "permission-prompt")
            let predicate = NSPredicate(format:
                "(label CONTAINS[c] %@ OR label CONTAINS[c] %@) AND identifier != %@", "Full Access", "All Photos", "permission-allow")
            let appFull = app.buttons.matching(predicate).firstMatch
            let systemFull = XCUIApplication(bundleIdentifier: "com.apple.springboard").buttons.matching(predicate).firstMatch
            // On current runtimes Photos permission can be hosted in the App,
            // rather than as a SpringBoard Alert. Search actual button labels.
            if appFull.waitForExistence(timeout: 10) {
                appFull.tap()
            } else {
                XCTAssertTrue(systemFull.waitForExistence(timeout: 15))
                systemFull.tap()
            }
        }
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
        XCTAssertTrue(app.staticTexts["archive-phase"].waitForExistence(timeout: 10))
        keep(app, "building")
        XCTAssertTrue(app.buttons["export-share-zip"].waitForExistence(timeout: 180))
        XCTAssertTrue(app.buttons["export-discard-work"].exists)
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
        XCTAssertEqual(app.buttons["export-share-zip"].label, "Share AI ZIP")
        keep(app, "ready")
        app.buttons["export-share-zip"].tap()
        XCTAssertTrue(app.descendants(matching: .any).matching(NSPredicate(format: "label == %@", "Copy")).firstMatch.waitForExistence(timeout: 20))
        keep(app, "share")
        // Cancel the native sheet; never copy/send or pretend it completed.
        let close = app.buttons.matching(NSPredicate(format: "label == %@ OR label == %@", "Close", "Cancel")).firstMatch
        if close.exists { close.tap() } else { app.swipeDown() }
        XCTAssertTrue(app.buttons["export-share-zip"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
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
    func testSourceDeletionConfirmationCancelOnly() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
        let delete = app.buttons["export-delete-sources"]
        XCTAssertTrue(delete.waitForExistence(timeout: 30))
        delete.tap()
        XCTAssertTrue(app.buttons["Continue to Photos deletion confirmation"].waitForExistence(timeout: 20))
        keep(app, "delete-confirmation")
        // Do not proceed into PhotoKit: capture the genuine App safety dialog only.
        XCTAssertTrue(app.buttons["Cancel"].exists)
        app.buttons["Cancel"].tap()
        XCTAssertTrue(delete.exists)
        app.terminate()
        app.launch()
        XCTAssertTrue(app.buttons["export-delete-sources"].waitForExistence(timeout: 30))
    }

    @MainActor
    private func keep(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "store-en-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
