import XCTest

/// Release UI captures on a fresh simulator, exclusively with fictional fixtures.
/// No sharing completion, save confirmation, or destructive action is performed.
final class S05ChineseStoreScreenshotsUITests: XCTestCase {
    @MainActor
    func testChineseStoreScreensOnFictionalSlides() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(zh-Hans)", "-AppleLocale", "zh_CN"]
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
                "(label CONTAINS[c] %@ OR label CONTAINS[c] %@) AND identifier != %@", "完全访问", "所有照片", "permission-allow")
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
        XCTAssertEqual(app.buttons["export-share-zip"].label, "分享 AI 资料包（ZIP）")
        keep(app, "ready")
        XCTAssertTrue(app.buttons["查看 PDF"].exists)
        app.buttons["查看 PDF"].tap()
        XCTAssertTrue(app.buttons["完成"].waitForExistence(timeout: 15))
        Thread.sleep(forTimeInterval: 3)
        keep(app, "pdf")
        app.buttons["完成"].tap()
        XCTAssertTrue(app.buttons["export-share-zip"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
    }

    @MainActor
    private func keep(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "store-zh-hans-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
