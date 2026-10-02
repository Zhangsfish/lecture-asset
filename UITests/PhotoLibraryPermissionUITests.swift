import XCTest

final class PhotoLibraryPermissionUITests: XCTestCase {
    @MainActor
    func testFullReadWritePermissionOpensSyntheticGrid() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()

        let allow = app.buttons["permission-allow"]
        XCTAssertTrue(allow.waitForExistence(timeout: 15), "Expected the real PhotoKit permission gate")
        let gateImage = XCTAttachment(screenshot: app.screenshot())
        gateImage.name = "s05-photos-permission-gate"
        gateImage.lifetime = .keepAlways
        add(gateImage)
        let about = app.buttons["about-open"]
        XCTAssertTrue(about.exists)
        about.tap()
        XCTAssertTrue(app.staticTexts["Privacy"].waitForExistence(timeout: 5))
        let helpImage = XCTAttachment(screenshot: app.screenshot())
        helpImage.name = "s05-about-before-photos-access"
        helpImage.lifetime = .keepAlways
        add(helpImage)
        XCTAssertFalse(XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts.firstMatch.exists,
                       "Opening local help must not request Photos access")
        app.buttons["about-close"].tap()
        XCTAssertTrue(allow.exists, "Closing About must return to the full-access gate")
        allow.tap()

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alert = springboard.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 15), "Expected the iOS Photos permission alert")
        let fullAccess = alert.buttons.matching(NSPredicate(
            format: "label CONTAINS[c] %@ OR label CONTAINS[c] %@",
            "Full Access", "All Photos"
        )).firstMatch
        XCTAssertTrue(fullAccess.exists, "Available permission buttons: \(alert.buttons.allElementsBoundByIndex.map(\.label))")
        fullAccess.tap()

        let grid = app.collectionViews["photo-grid"]
        XCTAssertTrue(grid.waitForExistence(timeout: 20), "Full authorization should show PhotoGridView")
        XCTAssertTrue(app.cells["photo-cell-0"].waitForExistence(timeout: 20),
                      "The PhotoKit grid should contain the imported synthetic images")
        let galleryImage = XCTAttachment(screenshot: app.screenshot())
        galleryImage.name = "s05-synthetic-selection"
        galleryImage.lifetime = .keepAlways
        add(galleryImage)
        XCTAssertTrue(app.buttons["about-open"].exists)
        XCTAssertFalse(allow.exists)
    }
}
