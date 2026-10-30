import XCTest

/// Only real system permission UI and local help; no processing or deletion.
class AppReviewPermissionUIBase: XCTestCase {
    @MainActor
    func keep(_ name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = "review-" + name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func launchGate(_ chinese: Bool) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", chinese ? "(zh-Hans)" : "(en)",
                               "-AppleLocale", chinese ? "zh_CN" : "en_US"]
        app.launch()
        let skip = app.buttons["tutorial-skip"]
        if skip.waitForExistence(timeout: 5) { skip.tap() }
        let action = app.buttons["permission-allow"]
        XCTAssertTrue(action.waitForExistence(timeout: 20))
        XCTAssertEqual(action.label, chinese ? "继续" : "Continue")
        XCTAssertTrue(action.isHittable)
        keep(chinese ? "zh-gate" : "en-gate")
        return app
    }

    @MainActor
    func localHelp(_ app: XCUIApplication) {
        app.buttons["about-open"].tap()
        XCTAssertTrue(app.buttons["tutorial-replay"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["about-copy-email"].exists)
        XCTAssertFalse(XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch.exists)
        keep("help-without-full-photos")
        app.buttons["about-close"].tap()
    }

    @MainActor
    func prompt(_ app: XCUIApplication) -> XCUIElement {
        app.buttons["permission-allow"].tap()
        let alert = XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 20), "Expected the genuine Photos authorization alert")
        keep("genuine-system-photos-choices")
        return alert
    }

    @MainActor
    func fullChoice(_ alert: XCUIElement) -> XCUIElement {
        alert.buttons.matching(NSPredicate(format:
            "label CONTAINS[c] %@ OR label CONTAINS[c] %@ OR label CONTAINS %@ OR label CONTAINS %@",
            "Full Access", "All Photos", "完全访问", "所有照片")).firstMatch
    }

    @MainActor
    func limitedChoice(_ alert: XCUIElement) -> XCUIElement {
        alert.buttons.matching(NSPredicate(format:
            "label CONTAINS[c] %@ OR label CONTAINS[c] %@ OR label CONTAINS %@ OR label CONTAINS %@ OR label CONTAINS %@",
            "Select Photos", "Limit", "选择照片", "选取照片", "限制访问")).firstMatch
    }

    @MainActor
    func blockedSettings(_ app: XCUIApplication, _ chinese: Bool) {
        let settings = app.buttons[chinese ? "打开设置" : "Open Settings"]
        XCTAssertTrue(settings.waitForExistence(timeout: 15))
        XCTAssertFalse(app.buttons["permission-allow"].exists)
        XCTAssertFalse(app.collectionViews["photo-grid"].exists)
        XCTAssertFalse(app.buttons["processing-start"].exists)
        localHelp(app)
        keep("blocked-with-settings")
        settings.tap()
        let preferences = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        XCTAssertTrue(preferences.wait(for: .runningForeground, timeout: 15))
        keep("real-settings-opened")
    }

    @MainActor
    func denied(_ chinese: Bool) {
        let app = launchGate(chinese)
        localHelp(app)
        let alert = prompt(app)
        XCTAssertTrue(fullChoice(alert).exists)
        XCTAssertTrue(limitedChoice(alert).exists)
        let deny = alert.buttons.matching(NSPredicate(format:
            "label CONTAINS[c] %@ OR label CONTAINS %@", "Don", "不允许")).firstMatch
        XCTAssertTrue(deny.exists, "Apple must retain the denial choice")
        deny.tap()
        blockedSettings(app, chinese)
    }

    @MainActor
    func authorized(_ chinese: Bool) {
        let app = launchGate(chinese)
        let full = fullChoice(prompt(app))
        XCTAssertTrue(full.exists)
        full.tap()
        XCTAssertTrue(app.collectionViews["photo-grid"].waitForExistence(timeout: 20))
        XCTAssertTrue(app.cells["photo-cell-0"].waitForExistence(timeout: 20))
        XCTAssertFalse(app.buttons["permission-allow"].exists)
        keep("full-access-synthetic-grid")
    }

    @MainActor
    func limited(_ chinese: Bool) {
        let app = launchGate(chinese)
        let select = limitedChoice(prompt(app))
        XCTAssertTrue(select.exists)
        select.tap()
        // Actual iOS 26.5 AX evidence: Apple's remote picker exposes photos as
        // Images named PXGGridLayout-Info, not UICollectionView cells.
        let photo = app.images.matching(identifier: "PXGGridLayout-Info").firstMatch
        guard photo.waitForExistence(timeout: 20) else {
            keep("limited-picker-missing-photo")
            XCTFail("Expected a photo in Apple's real limited-library picker")
            return
        }
        keep("limited-picker-synthetic-only")
        photo.tap()
        let done = app.buttons.matching(NSPredicate(format:
            "identifier == %@ OR label == %@ OR label == %@ OR label BEGINSWITH %@ OR label BEGINSWITH %@",
            "Update", "Done", "完成", "Allow Access", "允许访问")).firstMatch
        XCTAssertTrue(done.waitForExistence(timeout: 10))
        done.tap()
        blockedSettings(app, chinese)
    }
}

final class AppReviewEnglishPermissionUITests: AppReviewPermissionUIBase {
    @MainActor func testContinueThenDenied() { denied(false) }
    @MainActor func testContinueThenFullAccess() { authorized(false) }
    @MainActor func testContinueThenLimited() { limited(false) }
}

final class AppReviewChinesePermissionUITests: AppReviewPermissionUIBase {
    @MainActor func testContinueThenDenied() { denied(true) }
    @MainActor func testContinueThenFullAccess() { authorized(true) }
    @MainActor func testContinueThenLimited() { limited(true) }
}
