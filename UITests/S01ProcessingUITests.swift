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
        XCTAssertEqual(confirm.label, "Next: Review photos")
        confirm.tap()
        let start = app.buttons["processing-start"]
        XCTAssertTrue(start.waitForExistence(timeout: 10))
        let reviewImage = XCTAttachment(screenshot: app.screenshot())
        reviewImage.name = "s05-synthetic-review"
        reviewImage.lifetime = .keepAlways
        add(reviewImage)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(
            format: "label CONTAINS %@", "Tap to remove a mistake"
        )).firstMatch.exists)
        start.tap()

        let phase = app.staticTexts["processing-phase"]
        XCTAssertTrue(
            phase.waitForExistence(timeout: 20),
            "Expected processing screen; visible text: \(app.staticTexts.allElementsBoundByIndex.map(\.label))"
        )
        let completed = NSPredicate(format: "label == %@", "Photos prepared")
        expectation(for: completed, evaluatedWith: phase)
        waitForExpectations(timeout: 90)
        XCTAssertFalse(app.staticTexts["processing-progress"].exists)
        XCTAssertFalse(app.buttons["Copy safe page measurements"].exists)
        let processedImage = XCTAttachment(screenshot: app.screenshot())
        processedImage.name = "s05-synthetic-jpeg-complete"
        processedImage.lifetime = .keepAlways
        add(processedImage)

        app.terminate()
        app.launch()
        let recovered = app.staticTexts["processing-phase"]
        XCTAssertTrue(recovered.waitForExistence(timeout: 30))
        XCTAssertEqual(recovered.label, "Photos prepared", "The private per-page checkpoint must survive app restart")
        app.buttons["about-open"].tap()
        XCTAssertTrue(app.staticTexts["Privacy"].waitForExistence(timeout: 5))
        app.buttons["about-close"].tap()
        XCTAssertEqual(app.staticTexts["processing-phase"].label, "Photos prepared",
                       "About must not replace the recovered processing job")
    }
}
