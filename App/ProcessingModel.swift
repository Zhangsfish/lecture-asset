import Foundation
import Photos
import SwiftUI

@MainActor
final class ProcessingModel: ObservableObject {
    @Published private(set) var job: ProcessingJob?
    @Published private(set) var isRestoring = true
    @Published private(set) var storageFailed = false
    @Published private(set) var pauseRequested = false

    private let pipeline = CanonicalStillPipeline()
    private var activeTask: Task<Void, Never>?

    init() {
        Task { await restore() }
    }

    func start(pages: [JobPage]) throws {
        guard !isRestoring, job == nil, !pages.isEmpty,
              pages.count <= 200, PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized
        else { throw PageProcessingError(code: .permissionLost) }
        let newJob = ProcessingJob(pages: pages)
        // Persist the entire frozen source set and page order before any PhotoKit request.
        try JobStore.save(newJob)
        job = newJob
        pauseRequested = false
        run()
    }

    func pauseAfterCurrentPage() {
        guard job?.phase == .processing else { return }
        pauseRequested = true
    }

    func retryCheckpoint() {
        guard storageFailed, let current = job, activeTask == nil else { return }
        guard persist(current) else { return }
        if current.phase == .processing { run() }
    }

    func resume() {
        guard var current = job, current.phase == .paused, activeTask == nil else { return }
        pauseRequested = false
        current.phase = .processing
        guard persist(current) else { return }
        run()
    }

    func retryFailedPage() {
        guard var current = job, current.phase == .failed,
              let index = current.pages.firstIndex(where: { $0.phase == .failed }), activeTask == nil
        else { return }
        current.pages[index].phase = .pending
        current.pages[index].failure = nil
        current.phase = .processing
        pauseRequested = false
        guard persist(current) else { return }
        run()
    }

    func removeFailedPage() {
        guard var current = job, current.phase == .failed, current.pages.count > 1,
              let failedIndex = current.pages.firstIndex(where: { $0.phase == .failed }),
              !current.pages.dropFirst(failedIndex + 1).contains(where: { $0.phase == .completed }),
              activeTask == nil else { return }
        let failed = current.pages.remove(at: failedIndex)
        // Serial processing means only pending pages follow the failure; no later JPEG needs moving.
        for index in current.pages.indices { current.pages[index].pageIndex = index + 1 }
        current.phase = current.pages.allSatisfy { $0.phase == .completed } ? .completed : .processing
        guard persist(current) else { return }
        if let orphan = try? JobStore.imageURL(for: failed, in: current) {
            try? FileManager.default.removeItem(at: orphan)
        }
        if current.phase == .processing { run() }
    }

    func imageURL(for page: JobPage) -> URL? {
        guard let job, page.phase == .completed else { return nil }
        return try? JobStore.imageURL(for: page, in: job)
    }

    private func restore() async {
        do {
            let recovered = try await Task.detached(priority: .utility) { () -> ProcessingJob? in
                guard var saved = try JobStore.loadLatest() else { return nil }
                var changed = false
                for index in saved.pages.indices where saved.pages[index].phase == .completed {
                    if (try? JobStore.verifyCompleted(saved.pages[index], in: saved)) != true {
                        saved.pages[index].phase = .failed
                        saved.pages[index].failure = .checkpointInvalid
                        changed = true
                    }
                }
                if saved.pages.contains(where: { $0.phase == .failed }) {
                    saved.phase = .failed
                    changed = true
                } else if saved.phase == .processing {
                    saved.phase = .paused
                    changed = true
                }
                if changed { try JobStore.save(saved) }
                return saved
            }.value
            job = recovered
        } catch {
            storageFailed = true
        }
        isRestoring = false
    }

    private func run() {
        guard activeTask == nil, !storageFailed, job?.phase == .processing else { return }
        activeTask = Task {
            defer { activeTask = nil }
            while let current = job, current.phase == .processing,
                  let next = current.nextPage {
                if pauseRequested || Task.isCancelled {
                    var paused = current
                    paused.phase = .paused
                    _ = persist(paused)
                    return
                }
                do {
                    let result = try await pipeline.process(next, in: current)
                    guard var updated = job,
                          let index = updated.pages.firstIndex(where: { $0.assetIdentifier == next.assetIdentifier })
                    else { return }
                    updated.pages[index].phase = .completed
                    updated.pages[index].failure = nil
                    updated.pages[index].sourceStillBytes = result.sourceStillBytes
                    updated.pages[index].width = result.width
                    updated.pages[index].height = result.height
                    updated.pages[index].jpegBytes = result.jpegBytes
                    updated.pages[index].sha256 = result.sha256
                    updated.pages[index].memoryBytesPeakPage = result.memoryBytesPeakPage
                    updated.pages[index].memoryBytesAfterPage = result.memoryBytesAfterPage
                    guard persist(updated) else { return } // Per-page checkpoint before continuing.
                } catch {
                    guard var failed = job,
                          let index = failed.pages.firstIndex(where: { $0.assetIdentifier == next.assetIdentifier })
                    else { return }
                    failed.pages[index].phase = .failed
                    failed.pages[index].failure = (error as? PageProcessingError)?.code ?? .jpegFailed
                    failed.phase = .failed
                    _ = persist(failed)
                    return
                }
            }
            guard var finished = job, finished.phase == .processing else { return }
            finished.phase = pauseRequested ? .paused : .completed
            _ = persist(finished)
        }
    }

    @discardableResult
    private func persist(_ updated: ProcessingJob) -> Bool {
        do {
            try JobStore.save(updated)
            job = updated
            storageFailed = false
            return true
        } catch {
            storageFailed = true
            return false
        }
    }
}
