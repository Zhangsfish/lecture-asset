import Foundation
import XCTest
@testable import Lecture_Asset

final class S05TutorialTests: XCTestCase {
    func testFirstVisitIsOnceAndLegacyJobRootSuppressesAutomaticTutorial() throws {
        let base = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: base) }
        let fresh = base.appending(path: "new")
        XCTAssertTrue(TutorialVisitStore.reserveFirstVisit(at: fresh))
        XCTAssertFalse(TutorialVisitStore.reserveFirstVisit(at: fresh))
        XCTAssertTrue(FileManager.default.fileExists(atPath: fresh.appending(path: "tutorial-visit").path))
        let legacy = base.appending(path: "legacy")
        try FileManager.default.createDirectory(at: legacy.appending(path: "jobs"), withIntermediateDirectories: true)
        XCTAssertFalse(TutorialVisitStore.reserveFirstVisit(at: legacy))
        XCTAssertFalse(FileManager.default.fileExists(atPath: legacy.appending(path: "tutorial-visit").path))
    }
}
