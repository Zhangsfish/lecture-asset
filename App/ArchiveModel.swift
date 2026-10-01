import ArchiveCore
import Foundation
import SwiftUI

@MainActor
final class ArchiveModel: ObservableObject {
    @Published private(set) var state: ArchiveState?
    @Published private(set) var isBusy = false
    @Published private(set) var exportBusy = false
    @Published private(set) var deletionSummary: SourceDeletionSummary?
    @Published private(set) var exportError: SourceCleanupFailure?
    private var task: Task<Void, Never>?

    func restore(job: ProcessingJob) {
        guard !isBusy, state?.jobId != job.id else { return }
        isBusy = true
        Task {
            let loaded = await Task.detached(priority: .utility) { () -> ArchiveState? in
                guard var saved = try? ArchiveStore.load(job: job) else { return nil }
                if saved.phase == .ready {
                    if (try? ArchiveStore.verifyReady(saved, job: job)) != true {
                        saved.phase = .failed
                        saved.zipShareReceipt = nil
                        saved.failureCode = "archive_integrity_failed"
                        saved.failureStage = "ready_restore_validation"
                        try? ArchiveStore.save(saved, job: job)
                    } else if let receipt = saved.zipShareReceipt {
                        let current = try? ArchiveStore.verifiedZIPIdentity(saved, job: job).0
                        if current != receipt.identity {
                            saved.zipShareReceipt = nil
                            try? ArchiveStore.save(saved, job: job)
                        }
                    }
                } else if saved.phase == .processing {
                    saved.phase = .paused
                    try? ArchiveStore.save(saved, job: job)
                }
                return saved
            }.value
            state = loaded
            isBusy = false
            if loaded?.zipShareReceipt?.externalSaveConfirmed == true {
                Task { await refreshDeletionEligibility(job: job) }
            }
        }
    }

    func startOrRetry(job: ProcessingJob) {
        guard job.phase == .completed, !isBusy, task == nil else { return }
        var current = state?.jobId == job.id ? state! : ArchiveState(jobId: job.id)
        current.phase = .processing
        // A rebuild always revokes the old share and external-save confirmation,
        // even when the new ZIP happens to have identical bytes.
        current.zipShareReceipt = nil
        deletionSummary = nil
        current.failureCode = nil
        current.failureStage = nil
        do { try ArchiveStore.save(current, job: job) }
        catch {
            current.phase = .failed; current.failureCode = "checkpoint_write_failed"
            state = current
            return
        }
        state = current; isBusy = true
        let initial = current
        task = Task.detached(priority: .utility) { [weak self] in
            var saved = initial
            var stage = "ocr"
            do {
                guard let schema = Bundle.main.url(forResource: "manifest-v1.schema", withExtension: "json") else {
                    throw ArchiveFailure.invalid("missing schema resource")
                }
                for page in job.pages {
                    if saved.ocrByPage[page.pageIndex] == nil {
                        let location = try JobStore.imageURL(for: page, in: job)
                        guard try JobStore.verifyCompleted(page, in: job) else {
                            throw ArchiveFailure.invalid("canonical page changed")
                        }
                        let before = ArchiveMemory.footprint() ?? 0
                        let result = VisionOCR.recognize(location)
                        let after = ArchiveMemory.footprint() ?? 0
                        saved.ocrByPage[page.pageIndex] = result
                        saved.memoryAfterPage[page.pageIndex] = after
                        saved.memoryPeakPage[page.pageIndex] = max(before, after)
                        try ArchiveStore.save(saved, job: job)
                        let snapshot = saved
                        await MainActor.run { self?.state = snapshot }
                    }
                }
                stage = "build"
                let inputs = try job.pages.map { page -> ArchiveInputPage in
                    guard let ocr = saved.ocrByPage[page.pageIndex], let width = page.width,
                          let height = page.height, let bytes = page.jpegBytes, let sha = page.sha256 else {
                        throw ArchiveFailure.invalid("missing frozen page")
                    }
                    return ArchiveInputPage(sourceURL: try JobStore.imageURL(for: page, in: job),
                                            record: ArchivePage(number: page.pageIndex,
                                                selectionIndex: page.selectionIndex,
                                                capturedAt: page.capturedAt.map(ArchiveDate.iso),
                                                width: width, height: height, bytes: bytes, sha256: sha,
                                                isLivePhoto: page.isLivePhoto,
                                                ocr: ocr.normalizedForManifest()))
                }
                let date = ArchiveDate.titleDate(captured: job.pages.map(\.capturedAt), jobCreatedAt: job.createdAt)
                let result = try ArchiveBuilder.build(pages: inputs, archiveID: saved.archiveId,
                    title: "Lecture \(date)", jobCreatedAt: job.createdAt,
                    destination: ArchiveStore.outputDirectory(job: job), schemaURL: schema)
                saved.zipName = result.zipURL.lastPathComponent
                saved.pdfName = result.pdfURL.lastPathComponent
                saved.zipSha256 = result.zipSHA256
                saved.pdfSha256 = result.pdfSHA256
                saved.pdfMemoryAfterPage = result.pdfMemoryAfterPage
                saved.pdfMemoryPeakPage = result.pdfMemoryPeakPage
                saved.pdfImageSha256ByPage = result.pdfImageSHA256ByPage
                saved.phase = .ready
                stage = "ready_validation"
                guard try ArchiveStore.verifyReady(saved, job: job) else {
                    throw ArchiveFailure.invalid("ready validation")
                }
                stage = "checkpoint"
                try ArchiveStore.save(saved, job: job)
            } catch {
                saved.phase = .failed
                saved.failureStage = stage
                if let schemaError = error as? SchemaError {
                    saved.failureCode = "schema_validation_failed:\(schemaError.safeDiagnostic)"
                } else if let archiveError = error as? ArchiveFailure {
                    saved.failureCode = archiveError.description
                } else {
                    let problem = error as NSError
                    let safeDomain = problem.domain.range(of: #"^[A-Za-z0-9._-]{1,80}$"#,
                                                          options: .regularExpression) == nil
                        ? "other" : problem.domain
                    saved.failureCode = "archive_io_or_schema_failed:\(safeDomain):\(problem.code)"
                }
                try? ArchiveStore.save(saved, job: job)
            }
            let snapshot = saved
            await MainActor.run {
                self?.state = snapshot
                self?.isBusy = false
                self?.task = nil
            }
        }
    }

    func prepareShare(kind: SharedFileKind, job: ProcessingJob) async -> SharePresentation? {
        guard !exportBusy, !isBusy, let current = state, current.jobId == job.id,
              current.phase == .ready, job.sourcesDeleted != true else { return nil }
        exportBusy = true
        defer { exportBusy = false }
        exportError = nil
        do {
            switch kind {
            case .pdf:
                let url = try await Task.detached(priority: .utility) {
                    try ArchiveStore.verifiedPDFURL(current, job: job)
                }.value
                guard state?.jobId == job.id, state?.archiveId == current.archiveId else {
                    throw SourceCleanupFailure.archiveChanged
                }
                return SharePresentation(kind: .pdf, url: url, zipIdentity: nil)
            case .zip:
                let (identity, url) = try await Task.detached(priority: .utility) {
                    try ArchiveStore.verifiedZIPIdentity(current, job: job)
                }.value
                guard var latest = state, latest.jobId == job.id,
                      latest.archiveId == current.archiveId, latest.phase == .ready else {
                    throw SourceCleanupFailure.archiveChanged
                }
                // Every new ZIP share attempt resets completion and external confirmation.
                latest.zipShareReceipt = ZIPShareReceipt(identity: identity)
                try ArchiveStore.save(latest, job: job)
                state = latest
                deletionSummary = nil
                return SharePresentation(kind: .zip, url: url, zipIdentity: identity)
            }
        } catch {
            revokeZIPReceipt(job: job)
            exportError = .archiveChanged
            deletionSummary = nil
            return nil
        }
    }

    func recordZIPShareResult(job: ProcessingJob, identity: ZIPShareIdentity,
                              completed: Bool) async {
        guard !exportBusy, var current = state, current.jobId == job.id,
              current.zipShareReceipt?.identity == identity else { return }
        exportBusy = true
        defer { exportBusy = false }
        do {
            if completed {
                let verificationState = current
                let actual = try await Task.detached(priority: .utility) {
                    try ArchiveStore.verifiedZIPIdentity(verificationState, job: job).0
                }.value
                guard actual == identity else { throw SourceCleanupFailure.archiveChanged }
            }
            current.zipShareReceipt?.finishShare(completed: completed)
            try ArchiveStore.save(current, job: job)
            state = current
            deletionSummary = nil
            exportError = completed ? nil : .shareIncomplete
        } catch {
            current.zipShareReceipt = nil
            try? ArchiveStore.save(current, job: job)
            state = current
            deletionSummary = nil
            exportError = .archiveChanged
        }
    }

    func confirmExternalSave(job: ProcessingJob) async {
        guard !exportBusy, var current = state, current.jobId == job.id,
              let receipt = current.zipShareReceipt, receipt.reportedCompleted else {
            exportError = .shareIncomplete
            return
        }
        exportBusy = true
        defer { exportBusy = false }
        do {
            let verificationState = current
            let actual = try await Task.detached(priority: .utility) {
                try ArchiveStore.verifiedZIPIdentity(verificationState, job: job).0
            }.value
            guard receipt.identity == actual else { throw SourceCleanupFailure.archiveChanged }
            current.zipShareReceipt?.confirmExternalSave()
            try ArchiveStore.save(current, job: job)
            state = current
            exportError = nil
            await refreshDeletionEligibility(job: job)
        } catch {
            current.zipShareReceipt = nil
            try? ArchiveStore.save(current, job: job)
            state = current
            deletionSummary = nil
            exportError = .archiveChanged
        }
    }

    @discardableResult
    func refreshDeletionEligibility(job: ProcessingJob) async -> SourceDeletionSummary? {
        deletionSummary = nil
        guard let current = state, current.jobId == job.id,
              let receipt = current.zipShareReceipt, receipt.reportedCompleted,
              receipt.externalSaveConfirmed, job.sourcesDeleted != true else { return nil }
        do {
            let (identity, _) = try await Task.detached(priority: .utility) {
                try ArchiveStore.verifiedZIPIdentity(current, job: job)
            }.value
            guard receipt.permitsDeletion(of: identity) else {
                throw SourceCleanupFailure.archiveChanged
            }
            let summary = try await Task.detached(priority: .utility) {
                try PhotoKitSourceDeletion.preflight(job: job)
            }.value
            guard state?.zipShareReceipt == receipt else { return nil }
            deletionSummary = summary
            exportError = nil
            return summary
        } catch {
            let failure = (error as? SourceCleanupFailure) ?? .archiveChanged
            if failure == .archiveChanged { revokeZIPReceipt(job: job) }
            exportError = failure
            return nil
        }
    }

    func deleteSourcesAfterConfirmation(job: ProcessingJob, processor: ProcessingModel) async {
        guard !exportBusy, let current = state, current.jobId == job.id,
              let receipt = current.zipShareReceipt,
              receipt.reportedCompleted && receipt.externalSaveConfirmed,
              processor.job?.id == job.id else { return }
        exportBusy = true
        deletionSummary = nil
        defer { exportBusy = false }
        do {
            try await SourceCleanupOperation.run {
                let (identity, _) = try await Task.detached(priority: .utility) {
                    try ArchiveStore.verifiedZIPIdentity(current, job: job)
                }.value
                guard receipt.permitsDeletion(of: identity), processor.job?.id == job.id else {
                    throw SourceCleanupFailure.archiveChanged
                }
                _ = try await Task.detached(priority: .utility) {
                    try PhotoKitSourceDeletion.preflight(job: job)
                }.value
            } delete: {
                try await PhotoKitSourceDeletion.delete(job: job)
            } purge: {
                try processor.completePhotoDeletionAndPurge()
            }
            state = nil
            exportError = nil
        } catch {
            if processor.job?.sourcesDeleted == true {
                exportError = .localPurgeFailed
            } else {
                let failure = (error as? SourceCleanupFailure) ?? .deletionCancelledOrFailed
                if failure == .archiveChanged { revokeZIPReceipt(job: job) }
                exportError = failure
            }
        }
    }

    func clearExportError() { exportError = nil }

    private func revokeZIPReceipt(job: ProcessingJob) {
        guard var current = state, current.jobId == job.id else { return }
        current.zipShareReceipt = nil
        try? ArchiveStore.save(current, job: job)
        state = current
        deletionSummary = nil
    }

    func safeMetrics(job: ProcessingJob) -> String {
        guard let state else { return "S02 NOT_RUN" }
        var lines = ["Lecture Asset S02; phase=\(state.phase.rawValue); pages=\(job.pages.count); " +
                     "ocr_completed=\(state.completedOCRCount); pdf_page_long_edge=\(ArchiveBuilder.pdfLongEdge); " +
                     "pdf_jpeg_quality=\(ArchiveBuilder.pdfJPEGQuality); long_image_raster=full"]
        if state.phase == .ready, let directory = try? ArchiveStore.outputDirectory(job: job),
           let zipName = state.zipName, let pdfName = state.pdfName {
            func bytes(_ name: String) -> Int {
                let attributes = try? FileManager.default.attributesOfItem(atPath: directory.appending(path: name).path)
                return (attributes?[.size] as? NSNumber)?.intValue ?? 0
            }
            let zipBytes = bytes(zipName)
            let pdfBytes = bytes(pdfName)
            lines.append("zip_bytes=\(zipBytes); pdf_bytes=\(pdfBytes); validated=true")
        }
        for page in job.pages {
            let ocr = state.ocrByPage[page.pageIndex]
            let after = state.memoryAfterPage[page.pageIndex].map { String(format: "%.1f", Double($0) / 1_048_576) } ?? "unknown"
            let peak = state.memoryPeakPage[page.pageIndex].map { String(format: "%.1f", Double($0) / 1_048_576) } ?? "unknown"
            let pdfAfter = state.pdfMemoryAfterPage[page.pageIndex].map { String(format: "%.1f", Double($0) / 1_048_576) } ?? "unknown"
            let pdfPeak = state.pdfMemoryPeakPage[page.pageIndex].map { String(format: "%.1f", Double($0) / 1_048_576) } ?? "unknown"
            lines.append("page=\(page.pageIndex), pixels=\(page.width ?? 0)x\(page.height ?? 0), " +
                         "ocr_status=\(ocr?.status ?? "pending"), ocr_blocks=\(ocr?.blocks.count ?? 0), " +
                         "vision_revision=\(ocr?.requestRevision.map { String($0) } ?? "unknown"), " +
                         "languages=\(ocr?.languages.joined(separator: ",") ?? "unknown"), " +
                         "ocr_memory_after_mib=\(after), ocr_memory_sample_peak_mib=\(peak), " +
                         "pdf_memory_after_mib=\(pdfAfter), pdf_memory_sample_peak_mib=\(pdfPeak)")
        }
        return lines.joined(separator: "\n")
    }

    func safeFailureDiagnostics(job: ProcessingJob) -> String {
        guard let state else { return "Lecture Asset S02; phase=unavailable" }
        let stage = state.failureStage ?? "unknown"
        let code = state.failureCode ?? "unknown"
        return "Lecture Asset S02; phase=\(state.phase.rawValue); pages=\(job.pages.count); " +
            "ocr_completed=\(state.completedOCRCount); failure_stage=\(stage); failure_code=\(code)"
    }
}
