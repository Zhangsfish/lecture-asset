import Foundation
import SelectionCore
import XCTest
@testable import LectureAsset

private actor SyntheticPageProcessor: StillPageProcessing {
    private var failingIndex: Int?
    init(failingIndex: Int) { self.failingIndex = failingIndex }
    func restoreCause() { failingIndex = nil }
    func process(_ page: JobPage, in job: ProcessingJob) async throws -> PageOutput {
        if let failingIndex, page.assetIdentifier == "synthetic-\(failingIndex)" {
            throw PageProcessingError(code: .photoKitFailed)
        }
        return PageOutput(sourceStillBytes: 10, width: 1, height: 1, jpegBytes: 10,
                          sha256: String(repeating: "a", count: 64),
                          memoryBytesPeakPage: 1, memoryBytesAfterPage: 1)
    }
}

final class S01RecoveryTests: XCTestCase {
    @MainActor
    func testDeterministicFailureThenCauseRestoredAndRetry() async throws {
        let synthetic = SyntheticPageProcessor(failingIndex: 1)
        let model = ProcessingModel(pipeline: synthetic, hasFullPhotoAccess: { true }, restoreExisting: false)
        try model.start(pages: [page(1)])
        defer { clean(model.job) }
        try await waitForPhase(.failed, model: model)
        XCTAssertEqual(model.job?.failedPage?.failure, .photoKitFailed)
        await synthetic.restoreCause()
        model.retryFailedPage()
        try await waitForPhase(.completed, model: model)
        XCTAssertEqual(model.job?.pages.map(\.pageIndex), [1])
        XCTAssertEqual(model.job?.completedCount, 1)
    }

    @MainActor
    func testExplicitFailedPageRemovalExcludesAssetAndRenumbers() async throws {
        let synthetic = SyntheticPageProcessor(failingIndex: 2)
        let model = ProcessingModel(pipeline: synthetic, hasFullPhotoAccess: { true }, restoreExisting: false)
        try model.start(pages: [page(1), page(2), page(3)])
        defer { clean(model.job) }
        try await waitForPhase(.failed, model: model)
        XCTAssertEqual(model.job?.failedPage?.assetIdentifier, "synthetic-2")
        model.removeFailedPage() // The explicit user action represented by the model API.
        try await waitForPhase(.completed, model: model)
        XCTAssertEqual(model.job?.pages.map(\.assetIdentifier), ["synthetic-1", "synthetic-3"])
        XCTAssertEqual(model.job?.pages.map(\.pageIndex), [1, 2])
        XCTAssertEqual(model.job?.completedCount, 2)
    }

    @MainActor
    private func page(_ index: Int) -> JobPage {
        JobPage(frozen: FrozenPage(pageIndex: index, localIdentifier: "synthetic-\(index)",
                                   capturedAt: Date(timeIntervalSince1970: TimeInterval(index)),
                                   selectionIndex: index), isLivePhoto: false)
    }

    @MainActor
    private func waitForPhase(_ phase: JobPhase, model: ProcessingModel) async throws {
        for _ in 0..<200 {
            if model.job?.phase == phase { return }
            try await Task.sleep(for: .milliseconds(25))
        }
        XCTFail("Timed out waiting for phase \(phase)")
    }

    @MainActor
    private func clean(_ job: ProcessingJob?) {
        if let job, let url = try? JobStore.directory(for: job) {
            try? FileManager.default.removeItem(at: url)
        }
    }
}
