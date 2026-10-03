import XCTest

final class S05D0StoreScreenshotUITests: XCTestCase {
    @MainActor
    func testChineseStoreStoryOnSyntheticLectureMedia() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(zh-Hans)", "-AppleLocale", "zh_CN"]
        app.launch()

        if app.buttons["tutorial-skip"].waitForExistence(timeout: 15) {
            app.buttons["tutorial-skip"].tap()
        }

        let allow = app.buttons["permission-allow"]
        XCTAssertTrue(allow.waitForExistence(timeout: 20))
        allow.tap()

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alert = springboard.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 20))
        let fullAccess = alert.buttons.matching(NSPredicate(
            format: "label CONTAINS[c] %@ OR label CONTAINS[c] %@ OR label CONTAINS[c] %@ OR label CONTAINS[c] %@",
            "完全访问", "所有照片", "Full Access", "All Photos"
        )).firstMatch
        XCTAssertTrue(fullAccess.exists, "Available permission buttons: \(alert.buttons.allElementsBoundByIndex.map(\.label))")
        fullAccess.tap()

        let firstCell = app.cells["photo-cell-0"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 30))
        firstCell.tap()
        keep(app, name: "01-select-lecture-photos")

        let confirm = app.buttons["selection-confirm"]
        XCTAssertTrue(confirm.waitForExistence(timeout: 10))
        confirm.tap()

        let start = app.buttons["processing-start"]
        XCTAssertTrue(start.waitForExistence(timeout: 10))
        keep(app, name: "02-review-capture-order")
        start.tap()

        let archiveStart = app.buttons["archive-start"]
        XCTAssertTrue(archiveStart.waitForExistence(timeout: 120))
        keep(app, name: "03-photos-prepared")
        archiveStart.tap()

        let saveZIP = app.buttons["export-share-zip"]
        XCTAssertTrue(saveZIP.waitForExistence(timeout: 180))
        keep(app, name: "04-save-zip-pdf-cleanup")

        app.buttons["about-open"].tap()
        XCTAssertTrue(app.buttons["tutorial-replay"].waitForExistence(timeout: 10))
        app.buttons["tutorial-replay"].tap()
        XCTAssertTrue(app.buttons["tutorial-next"].waitForExistence(timeout: 10))
        for _ in 0..<4 {
            app.buttons["tutorial-next"].tap()
            Thread.sleep(forTimeInterval: 1)
        }
        XCTAssertEqual(app.otherElements["tutorial-page"].label, "5 / 5")
        Thread.sleep(forTimeInterval: 3)
        keep(app, name: "05-hand-off-to-ai")
    }

    @MainActor
    private func keep(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "s05-d0-store-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
