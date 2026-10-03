import XCTest

/// Locale arguments are iOS standard test overrides, not App region logic.
class LocalizationUIBase: XCTestCase {
    @MainActor
    func launch(_ chinese: Bool, large: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", chinese ? "(zh-Hans)" : "(en)",
                               "-AppleLocale", chinese ? "zh_CN" : "en_US"]
        if large {
            app.launchArguments += ["-UIPreferredContentSizeCategoryName",
                                    "UICTContentSizeCategoryAccessibilityXXXL"]
        }
        app.launch()
        return app
    }

    @MainActor
    func keep(_ app: XCUIApplication, _ name: String, _ chinese: Bool) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "localization-\(chinese ? "zh-Hans" : "en")-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
        // Catch visible untranslated key fallback, and Chinese leakage in English.
        for text in app.staticTexts.allElementsBoundByIndex.map(\.label) {
            XCTAssertNil(text.range(of: #"^(app|permission|selection|confirm|processing|archive|export|about|tutorial)\.[A-Za-z]+$"#,
                                    options: .regularExpression))
            if !chinese {
                XCTAssertNil(text.range(of: #"[\u4E00-\u9FFF]"#, options: .regularExpression))
            }
        }
    }

    @MainActor
    func cancelDialog(_ app: XCUIApplication) {
        let cancel = app.buttons.matching(NSPredicate(format: "label == %@ OR label == %@", "Cancel", "取消")).firstMatch
        XCTAssertTrue(cancel.waitForExistence(timeout: 5))
        cancel.tap()
    }

    @MainActor
    func flow(_ chinese: Bool) {
        let app = launch(chinese)
        let titles = chinese ? ["长按滑动选择", "按拍摄时间排序", "生成 ZIP + PDF", "保存后再清理", "交给 AI"] :
                               ["Press and drag to select", "Capture-time order", "Generate ZIP + PDF", "Save, then clean up", "Hand it to AI"]
        for index in 0..<5 {
            let title = app.staticTexts["tutorial-title"]
            XCTAssertTrue(title.waitForExistence(timeout: 15))
            XCTAssertEqual(title.label, titles[index])
            Thread.sleep(forTimeInterval: 4)
            keep(app, "tutorial-\(index + 1)", chinese)
            app.buttons["tutorial-next"].tap()
        }
        let allow = app.buttons["permission-allow"]
        XCTAssertTrue(allow.waitForExistence(timeout: 10))
        XCTAssertEqual(allow.label, chinese ? "允许完整访问" : "Allow full access")
        keep(app, "permission-gate", chinese)
        app.buttons["about-open"].tap()
        XCTAssertTrue(app.buttons["tutorial-replay"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.buttons["tutorial-replay"].label, chinese ? "重播教程" : "Replay tutorial")
        keep(app, "about-before-permission", chinese)
        app.buttons["about-close"].tap()
        allow.tap()
        let alert = XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 20))
        let purpose = chinese ? "讲座照片整理需要完整照片图库权限" : "Lecture Asset needs full photo library access"
        XCTAssertTrue(alert.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", purpose)).firstMatch.exists)
        let permissionImage = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        permissionImage.name = "localization-\(chinese ? "zh-Hans" : "en")-system-permission"
        permissionImage.lifetime = .keepAlways
        add(permissionImage)
        let full = alert.buttons.matching(NSPredicate(format:
            "label CONTAINS[c] %@ OR label CONTAINS[c] %@ OR label CONTAINS %@ OR label CONTAINS %@",
            "Full Access", "All Photos", "完全访问", "所有照片")).firstMatch
        XCTAssertTrue(full.exists)
        full.tap()
        XCTAssertTrue(app.cells["photo-cell-0"].waitForExistence(timeout: 30))
        app.cells["photo-cell-0"].tap()
        app.cells["photo-cell-1"].tap()
        XCTAssertEqual(app.buttons["selection-confirm"].label, chinese ? "下一步：检查照片" : "Next: Review photos")
        keep(app, "selection", chinese)
        app.buttons["selection-confirm"].tap()
        XCTAssertTrue(app.buttons["processing-start"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.navigationBars[chinese ? "检查照片" : "Review photos"].exists)
        keep(app, "review", chinese)
        app.buttons["processing-start"].tap()
        XCTAssertTrue(app.buttons["archive-start"].waitForExistence(timeout: 120))
        XCTAssertEqual(app.buttons["archive-start"].label, chinese ? "生成 ZIP + PDF" : "Generate ZIP and PDF")
        keep(app, "photos-prepared", chinese)
        app.buttons["archive-start"].tap()
        XCTAssertTrue(app.buttons["export-share-zip"].waitForExistence(timeout: 180))
        XCTAssertEqual(app.staticTexts["archive-phase"].label, chinese ? "文件已生成" : "Files ready")
        XCTAssertEqual(app.buttons["export-share-zip"].label, chinese ? "保存 AI 资料包（ZIP）" : "Save AI ZIP")
        XCTAssertEqual(app.buttons["export-discard-work"].label,
                       chinese ? "保留相册照片，仅清除 App 内文件" : "Keep Photos, clear App files")
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
        keep(app, "archive-ready-cleanup", chinese)
        app.buttons["export-discard-work"].tap()
        XCTAssertTrue(app.buttons[chinese ? "只删除 App 文件" : "Discard App files only"].waitForExistence(timeout: 5))
        keep(app, "app-only-confirmation", chinese)
        cancelDialog(app)
        app.buttons["about-open"].tap()
        XCTAssertTrue(app.buttons["about-copy-email"].waitForExistence(timeout: 5))
        keep(app, "about-top", chinese)
        app.swipeUp()
        keep(app, "about-privacy-version", chinese)
        app.buttons["about-close"].tap()
        app.terminate()
        app.launch()
        XCTAssertTrue(app.buttons["export-share-zip"].waitForExistence(timeout: 30))
        XCTAssertFalse(app.buttons["export-delete-sources"].exists)
        keep(app, "recovered-ready", chinese)
    }

    @MainActor
    func deletionConfirmation(_ chinese: Bool) {
        let app = launch(chinese)
        let delete = app.buttons["export-delete-sources"]
        XCTAssertTrue(delete.waitForExistence(timeout: 30))
        delete.tap()
        let action = chinese ? "继续至系统照片删除确认" : "Continue to Photos deletion confirmation"
        XCTAssertTrue(app.buttons[action].waitForExistence(timeout: 20))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@",
            chinese ? "动态与声音没有归档" : "motion and sound are not archived")).firstMatch.exists)
        keep(app, "source-deletion-confirmation-CANCELLED", chinese)
        // Never tap the destructive action. Cancel keeps the exact source set/job.
        cancelDialog(app)
        XCTAssertTrue(delete.exists)
        app.terminate()
        app.launch()
        XCTAssertTrue(app.buttons["export-delete-sources"].waitForExistence(timeout: 30))
    }

    @MainActor
    func largeText(_ chinese: Bool) {
        let app = launch(chinese, large: true)
        XCTAssertTrue(app.buttons["about-open"].waitForExistence(timeout: 30))
        keep(app, "large-text-ready", chinese)
        app.buttons["about-open"].tap()
        XCTAssertTrue(app.buttons["tutorial-replay"].waitForExistence(timeout: 10))
        keep(app, "large-text-about", chinese)
        app.buttons["tutorial-replay"].tap()
        XCTAssertTrue(app.buttons["tutorial-next"].waitForExistence(timeout: 10))
        keep(app, "large-text-tutorial", chinese)
        XCTAssertTrue(app.buttons["tutorial-skip"].isHittable)
        app.buttons["tutorial-skip"].tap()
        app.buttons["about-close"].tap()
    }

    @MainActor
    func failureDetails(_ chinese: Bool) {
        let app = launch(chinese)
        XCTAssertTrue(app.staticTexts["archive-phase"].waitForExistence(timeout: 30))
        XCTAssertEqual(app.staticTexts["archive-phase"].label, chinese ? "归档失败" : "Archive failed")
        app.buttons[chinese ? "技术详情" : "Technical details"].tap()
        XCTAssertTrue(app.staticTexts[chinese ? "错误代码（供支持排查）" : "Error code (for support)"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["schema_validation_failed:$.pages[0]:required"].exists)
        keep(app, "safe-failure-details", chinese)
    }
}

final class EnglishLocalizationUITests: LocalizationUIBase {
    @MainActor func testNormalFlow() { flow(false) }
    @MainActor func testDeletionConfirmationCancelOnly() { deletionConfirmation(false) }
    @MainActor func testLargeText() { largeText(false) }
    @MainActor func testSafeFailureDetails() { failureDetails(false) }
}

final class ChineseLocalizationUITests: LocalizationUIBase {
    @MainActor func testNormalFlow() { flow(true) }
    @MainActor func testDeletionConfirmationCancelOnly() { deletionConfirmation(true) }
    @MainActor func testLargeText() { largeText(true) }
    @MainActor func testSafeFailureDetails() { failureDetails(true) }
}
