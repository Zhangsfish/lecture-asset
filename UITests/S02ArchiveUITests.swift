import XCTest

final class S02ArchiveUITests: XCTestCase {
    @MainActor
    func testArchiveReadyAndRestoredForSyntheticPhoto() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        let start = app.buttons["archive-start"]
        XCTAssertTrue(start.waitForExistence(timeout: 30), "S01 synthetic checkpoint must exist")
        start.tap()
        let phase = app.staticTexts["archive-phase"]
        XCTAssertTrue(phase.waitForExistence(timeout: 20))
        expectation(for: NSPredicate(format: "label == %@", "Archive and PDF ready"), evaluatedWith: phase)
        waitForExpectations(timeout: 180)
        XCTAssertTrue(app.buttons["Inspect PDF"].exists)
        app.terminate()
        app.launch()
        let restored = app.staticTexts["archive-phase"]
        XCTAssertTrue(restored.waitForExistence(timeout: 30))
        XCTAssertEqual(restored.label, "Archive and PDF ready")
    }
}
