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
        XCTAssertEqual(PHAsset.fetchAssets(with: .image, options: nil).count, 6,
                       "Only the six CI synthetic photos may exist in this simulator")
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
        XCTAssertEqual(PHAsset.fetchAssets(with: .image, options: nil).count, 6)
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
