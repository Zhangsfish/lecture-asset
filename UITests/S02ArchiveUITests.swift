import XCTest

final class S02ArchiveUITests: XCTestCase {
    @MainActor
    func testArchiveReadyAndRestoredForSyntheticPhoto() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        let start = app.buttons["archive-start"]
        if !start.waitForExistence(timeout: 10) {
            let allow = app.buttons["permission-allow"]
            if allow.exists {
                allow.tap()
                let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
                let alert = springboard.alerts.firstMatch
                XCTAssertTrue(alert.waitForExistence(timeout: 20))
                let full = alert.buttons.matching(NSPredicate(
                    format: "label CONTAINS[c] %@ OR label CONTAINS[c] %@", "Full Access", "All Photos"
                )).firstMatch
                XCTAssertTrue(full.exists)
                full.tap()
            }
            let cell = app.cells["photo-cell-0"]
            XCTAssertTrue(cell.waitForExistence(timeout: 30))
            cell.tap()
            app.buttons["selection-confirm"].tap()
            app.buttons["processing-start"].tap()
            let processing = app.staticTexts["processing-phase"]
            expectation(for: NSPredicate(format: "label == %@", "Photos prepared"), evaluatedWith: processing)
            waitForExpectations(timeout: 90)
        }
        XCTAssertTrue(start.waitForExistence(timeout: 30))
        start.tap()
        let phase = app.staticTexts["archive-phase"]
        XCTAssertTrue(phase.waitForExistence(timeout: 20))
        expectation(for: NSPredicate(format: "label == %@", "Files ready"), evaluatedWith: phase)
        waitForExpectations(timeout: 180)
        XCTAssertTrue(app.buttons["View PDF"].exists)
        XCTAssertFalse(app.buttons["Copy safe archive measurements"].exists)
        XCTAssertFalse(app.buttons["Copy ZIP SHA-256 for checking the received file"].exists)
        let archiveImage = XCTAttachment(screenshot: app.screenshot())
        archiveImage.name = "s05-synthetic-archive-ready"
        archiveImage.lifetime = .keepAlways
        add(archiveImage)
        app.terminate()
        app.launch()
        let restored = app.staticTexts["archive-phase"]
        XCTAssertTrue(restored.waitForExistence(timeout: 30))
        XCTAssertEqual(restored.label, "Files ready")
    }
}
