import ArchiveCore
import Foundation
import SwiftUI

@MainActor
final class ArchiveModel: ObservableObject {
    @Published private(set) var state: ArchiveState?
    @Published private(set) var isBusy = false
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
                        saved.failureCode = "archive_integrity_failed"
                        saved.failureStage = "ready_restore_validation"
                        try? ArchiveStore.save(saved, job: job)
                    }
                } else if saved.phase == .processing {
                    saved.phase = .paused
                    try? ArchiveStore.save(saved, job: job)
                }
                return saved
            }.value
            state = loaded
            isBusy = false
        }
    }

    func startOrRetry(job: ProcessingJob) {
        guard job.phase == .completed, !isBusy, task == nil else { return }
        var current = state?.jobId == job.id ? state! : ArchiveState(jobId: job.id)
        current.phase = .processing
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
                                                isLivePhoto: page.isLivePhoto, ocr: ocr))
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
                if let archiveError = error as? ArchiveFailure {
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
