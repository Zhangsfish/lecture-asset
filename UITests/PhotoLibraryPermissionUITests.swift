import XCTest

final class PhotoLibraryPermissionUITests: XCTestCase {
    @MainActor
    func testFullReadWritePermissionOpensSyntheticGrid() {
        let app = XCUIApplication()
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()

        let allow = app.buttons["permission-allow"]
        XCTAssertTrue(allow.waitForExistence(timeout: 15), "Expected the real PhotoKit permission gate")
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
        XCTAssertFalse(allow.exists)
    }
}
