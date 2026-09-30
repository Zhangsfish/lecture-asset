import XCTest

final class S03ExportUITests: XCTestCase {
    @MainActor
    func testReadyArchiveShowsSeparateSharesAndKeepsDeleteLockedAcrossRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        let phase = app.staticTexts["archive-phase"]
        XCTAssertTrue(phase.waitForExistence(timeout: 30))
        XCTAssertEqual(phase.label, "Archive and PDF ready")
        XCTAssertTrue(app.buttons["export-share-zip"].exists)
        XCTAssertTrue(app.buttons["export-share-pdf"].exists)
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)

        app.terminate()
        app.launch()
        let restored = app.staticTexts["archive-phase"]
        XCTAssertTrue(restored.waitForExistence(timeout: 30))
        XCTAssertEqual(restored.label, "Archive and PDF ready")
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
    }
}
