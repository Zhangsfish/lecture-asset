import Foundation
import SelectionCore
import XCTest
@testable import Lecture_Asset

final class S03CleanupTests: XCTestCase {
    func testShareGateCancellationPDFOnlyAndExplicitConfirmation() {
        let identity = identityForTesting()
        // Sharing a PDF never creates the ZIP receipt.
        var pdfOnly: ZIPShareReceipt?
        XCTAssertNil(pdfOnly)

        var receipt = ZIPShareReceipt(identity: identity)
        receipt.finishShare(completed: false)
        receipt.confirmExternalSave()
        XCTAssertFalse(receipt.permitsDeletion(of: identity))

        receipt.finishShare(completed: true)
        XCTAssertFalse(receipt.permitsDeletion(of: identity))
        receipt.confirmExternalSave()
        XCTAssertTrue(receipt.permitsDeletion(of: identity))

        // A new share attempt, including one later cancelled, revokes the old gate.
        receipt = ZIPShareReceipt(identity: identity)
        receipt.finishShare(completed: false)
        XCTAssertFalse(receipt.permitsDeletion(of: identity))
        pdfOnly = nil
    }

    func testStaleZIPJobArchiveFilenameHashOrReplacementLocksDeletion() {
        let identity = identityForTesting()
        var receipt = ZIPShareReceipt(identity: identity)
        receipt.finishShare(completed: true)
        receipt.confirmExternalSave()
        XCTAssertFalse(receipt.permitsDeletion(of: ZIPShareIdentity(
            jobId: UUID(), archiveId: identity.archiveId, filename: identity.filename,
            sha256: identity.sha256, fileNumber: identity.fileNumber)))
        XCTAssertFalse(receipt.permitsDeletion(of: ZIPShareIdentity(
            jobId: identity.jobId, archiveId: UUID(), filename: identity.filename,
            sha256: identity.sha256, fileNumber: identity.fileNumber)))
        XCTAssertFalse(receipt.permitsDeletion(of: ZIPShareIdentity(
            jobId: identity.jobId, archiveId: identity.archiveId, filename: "rebuilt_AI.zip",
            sha256: identity.sha256, fileNumber: identity.fileNumber)))
        XCTAssertFalse(receipt.permitsDeletion(of: ZIPShareIdentity(
            jobId: identity.jobId, archiveId: identity.archiveId, filename: identity.filename,
            sha256: String(repeating: "b", count: 64), fileNumber: identity.fileNumber)))
        XCTAssertFalse(receipt.permitsDeletion(of: ZIPShareIdentity(
            jobId: identity.jobId, archiveId: identity.archiveId, filename: identity.filename,
            sha256: identity.sha256, fileNumber: identity.fileNumber + 1)))

        // A relaunch preserves only the recorded receipt, not evidence that the file
        // is still valid. A fresh identity check is required before deletion.
        let encoded = try! JSONEncoder().encode(receipt)
        let restored = try! JSONDecoder().decode(ZIPShareReceipt.self, from: encoded)
        XCTAssertFalse(restored.permitsDeletion(of: ZIPShareIdentity(
            jobId: identity.jobId, archiveId: identity.archiveId, filename: identity.filename,
            sha256: identity.sha256, fileNumber: identity.fileNumber + 1)))
    }

    func testFrozenExactSetRejectsDuplicatesMissingAndUnrelatedAssets() throws {
        let first = page(1, identifier: "synthetic-a", live: true)
        let second = page(2, identifier: "synthetic-b", live: false)
        var job = ProcessingJob(pages: [first, second])
        job.phase = .completed
        XCTAssertEqual(try ExactSourceSet.identifiers(in: job), ["synthetic-a", "synthetic-b"])
        try ExactSourceSet.validateFetched(requested: ["synthetic-a", "synthetic-b"],
                                            fetched: ["synthetic-b", "synthetic-a"])
        XCTAssertThrowsError(try ExactSourceSet.validateFetched(
            requested: ["synthetic-a", "synthetic-b"], fetched: ["synthetic-a"]))
        XCTAssertThrowsError(try ExactSourceSet.validateFetched(
            requested: ["synthetic-a", "synthetic-b"], fetched: ["synthetic-a", "synthetic-a"]))
        XCTAssertThrowsError(try ExactSourceSet.validateFetched(
            requested: ["synthetic-a", "synthetic-b"], fetched: ["synthetic-a", "unrelated"]))
        job.pages[1] = page(2, identifier: "synthetic-a", live: false)
        XCTAssertThrowsError(try ExactSourceSet.identifiers(in: job))
        job.pages[1] = page(3, identifier: "synthetic-b", live: false)
        XCTAssertThrowsError(try ExactSourceSet.identifiers(in: job))
    }

    @MainActor
    func testDeletionCancellationOrFailureRetainsJobAndSuccessPurgesOnlyItsFiles() async throws {
        let root = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        let work = root.appending(path: "job")
        let unrelated = root.appending(path: "unrelated")
        try FileManager.default.createDirectory(at: work, withIntermediateDirectories: true)
        try Data("synthetic ZIP".utf8).write(to: work.appending(path: "archive.zip"))
        try Data("other".utf8).write(to: unrelated)
        defer { try? FileManager.default.removeItem(at: root) }

        let fake = FakePhotoLibrary(identifiers: ["synthetic-a", "synthetic-b", "unrelated"])
        let requested = ["synthetic-a", "synthetic-b"]
        do {
            try await SourceCleanupOperation.run {
                try ExactSourceSet.validateFetched(requested: requested,
                                                    fetched: fake.fetched(requested))
            } delete: {
                throw SourceCleanupFailure.deletionCancelledOrFailed
            } purge: {
                try FileManager.default.removeItem(at: work)
            }
            XCTFail("Cancelled deletion must fail")
        } catch SourceCleanupFailure.deletionCancelledOrFailed {}
        XCTAssertTrue(FileManager.default.fileExists(atPath: work.appending(path: "archive.zip").path))
        XCTAssertEqual(fake.identifiers, ["synthetic-a", "synthetic-b", "unrelated"])

        try await SourceCleanupOperation.run {
            try ExactSourceSet.validateFetched(requested: requested,
                                                fetched: fake.fetched(requested))
        } delete: {
            fake.delete(requested)
        } purge: {
            try FileManager.default.removeItem(at: work)
        }
        XCTAssertFalse(FileManager.default.fileExists(atPath: work.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: unrelated.path))
        XCTAssertEqual(fake.identifiers, ["unrelated"])
    }

    private func identityForTesting() -> ZIPShareIdentity {
        ZIPShareIdentity(jobId: UUID(), archiveId: UUID(), filename: "synthetic_AI.zip",
                         sha256: String(repeating: "a", count: 64), fileNumber: 12)
    }

    private func page(_ number: Int, identifier: String, live: Bool) -> JobPage {
        var result = JobPage(frozen: FrozenPage(pageIndex: number, localIdentifier: identifier,
                                               capturedAt: nil, selectionIndex: number),
                             isLivePhoto: live)
        result.phase = .completed
        return result
    }
}

@MainActor
private final class FakePhotoLibrary {
    var identifiers: Set<String>
    init(identifiers: Set<String>) { self.identifiers = identifiers }
    func fetched(_ requested: [String]) -> [String] {
        requested.filter { identifiers.contains($0) }
    }
    func delete(_ requested: [String]) {
        identifiers.subtract(requested)
    }
}
