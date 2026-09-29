import XCTest

final class S01ProcessingUITests: XCTestCase {
    @MainActor
    func testSyntheticPhotoProcessesAndCheckpointSurvivesRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()

        let allow = app.buttons["permission-allow"]
        XCTAssertTrue(allow.waitForExistence(timeout: 20))
        allow.tap()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alert = springboard.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 20))
        let fullAccess = alert.buttons.matching(NSPredicate(
            format: "label CONTAINS[c] %@ OR label CONTAINS[c] %@",
            "Full Access", "All Photos"
        )).firstMatch
        XCTAssertTrue(fullAccess.exists)
        fullAccess.tap()

        let firstCell = app.cells["photo-cell-0"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 30))
        firstCell.tap()
        let confirm = app.buttons["selection-confirm"]
        XCTAssertTrue(confirm.waitForExistence(timeout: 10))
        confirm.tap()
        let start = app.buttons["processing-start"]
        XCTAssertTrue(start.waitForExistence(timeout: 10))
        start.tap()

        let phase = app.staticTexts["processing-phase"]
        XCTAssertTrue(
            phase.waitForExistence(timeout: 20),
            "Expected processing screen; visible text: \(app.staticTexts.allElementsBoundByIndex.map(\.label))"
        )
        let completed = NSPredicate(format: "label == %@", "Completed")
        expectation(for: completed, evaluatedWith: phase)
        waitForExpectations(timeout: 90)
        let finalProgress = app.staticTexts.matching(identifier: "processing-progress")
            .matching(NSPredicate(format: "label == %@", "1 / 1")).firstMatch
        XCTAssertTrue(finalProgress.exists)
        XCTAssertTrue(app.buttons["Copy safe page measurements"].exists)

        app.terminate()
        app.launch()
        let recovered = app.staticTexts["processing-phase"]
        XCTAssertTrue(recovered.waitForExistence(timeout: 30))
        XCTAssertEqual(recovered.label, "Completed", "The private per-page checkpoint must survive app restart")
    }
}
