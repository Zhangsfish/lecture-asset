import Foundation
import Photos
import XCTest
@testable import Lecture_Asset

/// Test-host-only staging, never compiled into the App. CI uses an isolated
/// simulator containing generated images. No sharing or PhotoKit deletion occurs.
final class LocalizationReceiptFixtureTests: XCTestCase {
    func testStageSyntheticReceiptForConfirmationVisualOnly() throws {
        #if targetEnvironment(simulator)
        let job = try XCTUnwrap(JobStore.loadLatest())
        XCTAssertEqual(job.totalCount, 2)
        XCTAssertEqual(job.phase, .completed)
        let sourceIDs = try ExactSourceSet.identifiers(in: job)
        let sources = PHAsset.fetchAssets(withLocalIdentifiers: sourceIDs, options: nil)
        XCTAssertEqual(sources.count, 2)
        let fixtureNames = Set((1...6).map { String(format: "%02d.jpg", $0) })
        sources.enumerateObjects { asset, _, _ in
            XCTAssertTrue(PHAssetResource.assetResources(for: asset).contains {
                fixtureNames.contains($0.originalFilename)
            }, "Frozen sources must be the imported numbered synthetic fixtures")
        }
        // Fresh iOS simulators also contain Apple's stock demonstration photos.
        // Record the actual total, then verify cancellation did not change it.
        let sourceCount = PHAsset.fetchAssets(with: .image, options: nil).count
        try Data(String(sourceCount).utf8).write(to: JobStore.directory(for: job)
            .appending(path: ".localization-test-source-count"), options: .atomic)
        var state = try XCTUnwrap(ArchiveStore.load(job: job))
        XCTAssertTrue(try ArchiveStore.verifyReady(state, job: job))
        let identity = try ArchiveStore.verifiedZIPIdentity(state, job: job).0
        var receipt = ZIPShareReceipt(identity: identity)
        receipt.finishShare(completed: true)
        receipt.confirmExternalSave()
        state.zipShareReceipt = receipt
        try ArchiveStore.save(state, job: job)
        #else
        throw XCTSkip("Fixture staging is isolated-simulator-only")
        #endif
    }

    func testStageSafeFailureForLocalizedDetails() throws {
        #if targetEnvironment(simulator)
        let job = try XCTUnwrap(JobStore.loadLatest())
        XCTAssertEqual(job.totalCount, 2)
        let baseline = try String(contentsOf: JobStore.directory(for: job)
            .appending(path: ".localization-test-source-count"), encoding: .utf8)
        XCTAssertEqual(PHAsset.fetchAssets(with: .image, options: nil).count, Int(baseline))
        var state = try XCTUnwrap(ArchiveStore.load(job: job))
        state.phase = .failed
        state.zipShareReceipt = nil
        state.failureStage = "build"
        state.failureCode = "schema_validation_failed:$.pages[0]:required"
        try ArchiveStore.save(state, job: job)
        #else
        throw XCTSkip("Fixture staging is isolated-simulator-only")
        #endif
    }
}
