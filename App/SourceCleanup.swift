import ArchiveCore
import Foundation
import Photos

/// Private export identity. The file number also detects replacing a ZIP at the same path.
struct ZIPShareIdentity: Codable, Equatable, Sendable {
    let jobId: UUID
    let archiveId: UUID
    let filename: String
    let sha256: String
    let fileNumber: UInt64
}

struct ZIPShareReceipt: Codable, Equatable, Sendable {
    let identity: ZIPShareIdentity
    var reportedCompleted = false
    var externalSaveConfirmed = false

    mutating func finishShare(completed: Bool) {
        reportedCompleted = completed
        externalSaveConfirmed = false
    }

    mutating func confirmExternalSave() {
        guard reportedCompleted else { return }
        externalSaveConfirmed = true
    }

    func permitsDeletion(of current: ZIPShareIdentity) -> Bool {
        identity == current && reportedCompleted && externalSaveConfirmed
    }
}

enum SourceCleanupFailure: Error, Equatable {
    case archiveChanged
    case shareIncomplete
    case permissionLost
    case invalidLedger
    case missingAsset
    case deletionCancelledOrFailed
    case localPurgeFailed
}

enum ExactSourceSet {
    /// The post-removal job ledger is the only source of deletion identifiers.
    static func identifiers(in job: ProcessingJob) throws -> [String] {
        guard job.phase == .completed, job.sourcesDeleted != true,
              (1...200).contains(job.pages.count),
              job.pages.enumerated().allSatisfy({ offset, page in
                  page.pageIndex == offset + 1 && page.phase == .completed &&
                  !page.assetIdentifier.isEmpty
              }) else { throw SourceCleanupFailure.invalidLedger }
        let identifiers = job.pages.map(\.assetIdentifier)
        guard Set(identifiers).count == job.pages.count else {
            throw SourceCleanupFailure.invalidLedger
        }
        return identifiers
    }

    static func validateFetched(requested: [String], fetched: [String]) throws {
        guard !requested.isEmpty, requested.count == fetched.count,
              Set(requested).count == requested.count,
              Set(fetched).count == fetched.count,
              Set(requested) == Set(fetched) else {
            throw SourceCleanupFailure.missingAsset
        }
    }
}

struct SourceDeletionSummary: Sendable, Equatable {
    let count: Int
    let livePhotoCount: Int
}

enum SharedFileKind: Sendable { case zip, pdf }

struct SharePresentation: Identifiable, Sendable {
    let id = UUID()
    let kind: SharedFileKind
    let url: URL
    let zipIdentity: ZIPShareIdentity?
}

/// The purge closure is never reached after a cancelled or failed PhotoKit operation.
@MainActor
enum SourceCleanupOperation {
    static func run(verify: () async throws -> Void,
                    delete: () async throws -> Void,
                    purge: () throws -> Void) async throws {
        try await verify()
        try await delete()
        try purge()
    }
}

enum PhotoKitSourceDeletion {
    static func preflight(job: ProcessingJob) throws -> SourceDeletionSummary {
        let assets = try exactAssets(for: job)
        return SourceDeletionSummary(count: assets.count,
            livePhotoCount: assets.filter { $0.mediaSubtypes.contains(.photoLive) }.count)
    }

    static func delete(job: ProcessingJob) async throws {
        // This is intentionally repeated after the App's own destructive confirmation.
        // Do not use a cached fetch or a date-range search.
        let assets = try exactAssets(for: job)
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }
    }

    private static func exactAssets(for job: ProcessingJob) throws -> [PHAsset] {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized else {
            throw SourceCleanupFailure.permissionLost
        }
        let identifiers = try ExactSourceSet.identifiers(in: job)
        let fetched = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        var assets: [PHAsset] = []
        fetched.enumerateObjects { asset, _, _ in assets.append(asset) }
        try ExactSourceSet.validateFetched(requested: identifiers,
                                            fetched: assets.map(\.localIdentifier))
        guard assets.allSatisfy({ $0.mediaType == .image }) else {
            throw SourceCleanupFailure.missingAsset
        }
        return assets
    }
}
