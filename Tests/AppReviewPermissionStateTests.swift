import Foundation
import Photos
import XCTest

/// Reads actual App-host PhotoKit status after the UI test. No production hook.
final class AppReviewPermissionStateTests: XCTestCase {
    func testHostPreparedReadWriteAuthorization() throws {
        let temporary = FileManager.default.temporaryDirectory
        let expectedURL = temporary.appending(path: "review-permission-expected.txt")
        guard FileManager.default.fileExists(atPath: expectedURL.path) else {
            throw XCTSkip("Only the focused disposable-simulator workflow stages this expectation")
        }
        defer { try? FileManager.default.removeItem(at: expectedURL) }
        let expected = try String(contentsOf: expectedURL, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        let actual: String
        switch status {
        case .notDetermined: actual = "notDetermined"
        case .restricted: actual = "restricted"
        case .denied: actual = "denied"
        case .limited: actual = "limited"
        case .authorized: actual = "authorized"
        @unknown default: actual = "unknown"
        }
        XCTAssertEqual(actual, expected)
        let data = try JSONSerialization.data(withJSONObject: [
            "expected": expected, "actual": actual, "match": expected == actual,
            "scope": "Actual App-host PHPhotoLibrary readWrite status; simulator only"
        ], options: [.sortedKeys])
        try data.write(to: temporary.appending(path: "review-permission-observed.json"), options: .atomic)
    }
}
