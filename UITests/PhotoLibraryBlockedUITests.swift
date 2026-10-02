import XCTest

final class PhotoLibraryBlockedUITests: XCTestCase {
    @MainActor
    func testDeniedPhotosBlocksProcessingButKeepsLocalHelp() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()

        XCTAssertFalse(app.buttons["permission-allow"].exists)
        XCTAssertTrue(app.buttons["Open Settings"].waitForExistence(timeout: 15))
        XCTAssertFalse(app.collectionViews["photo-grid"].exists)
        XCTAssertFalse(app.buttons["processing-start"].exists)

        app.buttons["about-open"].tap()
        XCTAssertTrue(app.staticTexts["Privacy"].waitForExistence(timeout: 5))
        app.buttons["about-close"].tap()
        XCTAssertTrue(app.buttons["Open Settings"].exists)
    }
}
