import SwiftUI
import UIKit
import PDFKit

struct ProcessingView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var model: ProcessingModel
    @State private var showingRemoveConfirmation = false
    @State private var pageToPreview: JobPage?
    @State private var copied = false
    @StateObject private var archive = ArchiveModel()
    @State private var showingPDF = false
    @State private var presentedShare: SharePresentation?
    @State private var showingSaveConfirmation = false
    @State private var showingDeleteConfirmation = false
    @State private var showingDiscardConfirmation = false
    @State private var pendingDeleteSummary: SourceDeletionSummary?

    var body: some View {
        Group {
            if let job = model.job {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(phaseKey(for: job.phase)).font(.title2.bold())
                            .accessibilityIdentifier("processing-phase")
                        ProgressView(value: Double(job.completedCount), total: Double(job.totalCount))
                        HStack {
                            Text("processing.current")
                            Text("\(job.failedPage?.pageIndex ?? job.nextPage?.pageIndex ?? job.totalCount) / \(job.totalCount)")
                        }
                        .accessibilityIdentifier("processing-progress")

                        if model.storageFailed {
                            Text("processing.storageFailed").foregroundStyle(.red)
                            Button("processing.retryCheckpoint") { model.retryCheckpoint() }
                        }
                        if job.sourcesDeleted == true {
                            Text("export.photosDeletedCleanupPending")
                            Button("export.retryPurge") { model.retryPurgeAfterPhotoDeletion() }
                                .buttonStyle(.borderedProminent)
                        }
                        if job.phase == .processing {
                            Button(model.pauseRequested ? "processing.pausePending" : "processing.pause") {
                                model.pauseAfterCurrentPage()
                            }
                            .disabled(model.pauseRequested)
                        }
                        if job.phase == .paused {
                            Button("processing.resume") { model.resume() }
                                .buttonStyle(.borderedProminent)
                        }
                        if let failed = job.failedPage {
                            Text(failureKey(for: failed.failure)).foregroundStyle(.red)
                            Button("processing.retry") { model.retryFailedPage() }
                                .buttonStyle(.borderedProminent)
                            if job.pages.count > 1 {
                                Button("processing.removeFailed", role: .destructive) {
                                    showingRemoveConfirmation = true
                                }
                            }
                        }
                        if job.phase == .completed && job.sourcesDeleted != true {
                            Text("processing.completeDetail")
                            if let archiveState = archive.state {
                                Text(archiveKey(for: archiveState.phase))
                                    .accessibilityIdentifier("archive-phase")
                                Text("\(archiveState.completedOCRCount) / \(job.totalCount) OCR")
                                if archiveState.phase == .failed {
                                    Text("archive.failedDetail").foregroundStyle(.red)
                                    Button("archive.copyFailure") {
                                        UIPasteboard.general.string = archive.safeFailureDiagnostics(job: job)
                                    }
                                    Button("archive.retry") { archive.startOrRetry(job: job) }
                                        .buttonStyle(.borderedProminent)
                                }
                                if archiveState.phase == .paused {
                                    Button("archive.resume") { archive.startOrRetry(job: job) }
                                        .buttonStyle(.borderedProminent)
                                }
                                if archiveState.phase == .ready {
                                    Text("archive.readyDetail")
                                    Button("archive.previewPDF") { showingPDF = true }
                                    Button("archive.copyMetrics") {
                                        UIPasteboard.general.string = archive.safeMetrics(job: job)
                                    }
                                    Divider()
                                    Button("export.shareZIP") {
                                        Task { presentedShare = await archive.prepareShare(kind: .zip, job: job) }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .accessibilityIdentifier("export-share-zip")
                                    Button("export.sharePDF") {
                                        Task { presentedShare = await archive.prepareShare(kind: .pdf, job: job) }
                                    }
                                    .accessibilityIdentifier("export-share-pdf")
                                    Button("export.copyZIPHash") {
                                        UIPasteboard.general.string = archiveState.zipSha256
                                    }
                                    if archiveState.zipShareReceipt?.reportedCompleted == true {
                                        Text("export.shareCompleted").font(.footnote)
                                        if archiveState.zipShareReceipt?.externalSaveConfirmed == true {
                                            Text("export.savedConfirmed").font(.footnote)
                                        } else {
                                            Button("export.confirmSaved") { showingSaveConfirmation = true }
                                                .accessibilityIdentifier("export-confirm-saved")
                                        }
                                    }
                                    if let summary = archive.deletionSummary {
                                        Button(role: .destructive) {
                                            Task {
                                                pendingDeleteSummary = await archive.refreshDeletionEligibility(job: job)
                                                showingDeleteConfirmation = pendingDeleteSummary != nil
                                            }
                                        } label: {
                                            Text("export.deleteSources") + Text(" \(summary.count)")
                                        }
                                        .accessibilityIdentifier("export-delete-sources")
                                    } else {
                                        Text("export.cleanupLockedHint")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            } else if !archive.isBusy {
                                Button("archive.start") { archive.startOrRetry(job: job) }
                                    .buttonStyle(.borderedProminent)
                                    .accessibilityIdentifier("archive-start")
                            }
                            if let inventory = try? JobStore.outputInventory(in: job) {
                                HStack {
                                    Text("processing.jpegCount")
                                    Text("\(inventory.jpegCount)")
                                    Text("processing.motionCount")
                                    Text("\(inventory.motionAudioCount)")
                                }
                                .font(.footnote.monospacedDigit())
                            }
                        }

                        if let error = archive.exportError {
                            Text(exportErrorKey(for: error)).foregroundStyle(.red)
                                .accessibilityIdentifier("export-error")
                        }

                        if job.phase != .processing && job.sourcesDeleted != true {
                            Button("export.discardWorkCopy", role: .destructive) {
                                showingDiscardConfirmation = true
                            }
                            .disabled(archive.isBusy || archive.exportBusy)
                        }

                        if job.completedCount > 0 {
                            Button(copied ? "processing.copied" : "processing.copyMetrics") {
                                UIPasteboard.general.string = diagnostics(for: job)
                                copied = true
                            }
                            ForEach(job.pages.filter { $0.phase == .completed }) { page in
                                Button {
                                    pageToPreview = page
                                } label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text("processing.page")
                                            Text("\(page.pageIndex)")
                                            if page.isLivePhoto { Text("processing.liveStill") }
                                        }
                                        .font(.headline)
                                        Text(metrics(for: page))
                                            .font(.footnote.monospacedDigit())
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("processing.title")
        .confirmationDialog("processing.removeConfirm", isPresented: $showingRemoveConfirmation) {
            Button("processing.removeFailed", role: .destructive) {
                model.removeFailedPage()
            }
        }
        .confirmationDialog("export.saveConfirmTitle", isPresented: $showingSaveConfirmation) {
            if let job = model.job {
                Button("export.saveConfirmAction") {
                    Task { await archive.confirmExternalSave(job: job) }
                }
            }
        }
        .confirmationDialog("export.deleteConfirmTitle", isPresented: $showingDeleteConfirmation) {
            if let job = model.job, pendingDeleteSummary != nil {
                Button("export.deleteConfirmAction", role: .destructive) {
                    Task { await archive.deleteSourcesAfterConfirmation(job: job, processor: model) }
                }
            }
        } message: {
            if let summary = pendingDeleteSummary {
                Text("export.deleteConfirmCount") + Text(" \(summary.count). ") +
                Text("export.deleteLiveWarning") + Text(" \(summary.livePhotoCount). ") +
                Text("export.deleteICloudWarning")
            }
        }
        .confirmationDialog("export.discardConfirmTitle", isPresented: $showingDiscardConfirmation) {
            Button("export.discardConfirmAction", role: .destructive) {
                model.discardWorkCopyKeepingPhotos()
            }
        } message: {
            Text("export.discardDetail")
        }
        .sheet(item: $pageToPreview) { page in
            if let url = model.imageURL(for: page) {
                CanonicalPagePreview(url: url)
            }
        }
        .sheet(isPresented: $showingPDF) {
            if let state = archive.state, let name = state.pdfName,
               let job = model.job, let folder = try? ArchiveStore.outputDirectory(job: job) {
                CompanionPDFPreview(url: folder.appending(path: name))
            }
        }
        .sheet(item: $presentedShare) { presentation in
            SystemFileShareSheet(url: presentation.url) { completed in
                guard presentation.kind == .zip, let identity = presentation.zipIdentity,
                      let job = model.job else { return }
                Task { await archive.recordZIPShareResult(job: job, identity: identity,
                                                          completed: completed) }
            }
        }
        .onAppear {
            if let job = model.job, job.phase == .completed { archive.restore(job: job) }
        }
        .onChange(of: model.job?.phase) { _, phase in
            if phase == .completed, let job = model.job { archive.restore(job: job) }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active, let job = model.job,
               archive.state?.zipShareReceipt?.externalSaveConfirmed == true {
                Task { await archive.refreshDeletionEligibility(job: job) }
            }
        }
    }

    private func exportErrorKey(for error: SourceCleanupFailure) -> LocalizedStringKey {
        switch error {
        case .archiveChanged: "export.errorArchiveChanged"
        case .shareIncomplete: "export.errorShareIncomplete"
        case .permissionLost: "export.errorPermission"
        case .invalidLedger: "export.errorLedger"
        case .missingAsset: "export.errorMissing"
        case .deletionCancelledOrFailed: "export.errorDelete"
        case .localPurgeFailed: "export.errorPurge"
        }
    }

    private func archiveKey(for phase: ArchivePhase) -> LocalizedStringKey {
        switch phase {
        case .processing: "archive.processing"
        case .paused: "archive.paused"
        case .failed: "archive.failed"
        case .ready: "archive.ready"
        }
    }

    private func phaseKey(for phase: JobPhase) -> LocalizedStringKey {
        switch phase {
        case .processing: "processing.active"
        case .paused: "processing.paused"
        case .failed: "processing.failed"
        case .completed: "processing.completed"
        }
    }

    private func failureKey(for failure: PageFailure?) -> LocalizedStringKey {
        switch failure {
        case .notDownloaded: "processing.notDownloaded"
        case .permissionLost: "processing.permissionLost"
        case .assetUnavailable: "processing.assetUnavailable"
        case .degradedResult: "processing.degraded"
        case .checkpointInvalid: "processing.checkpointInvalid"
        case .photoKitFailed, .sourceInvalid, .dimensionChanged, .jpegFailed, .none:
            "processing.pageFailed"
        }
    }

    private func metrics(for page: JobPage) -> String {
        let width = page.width ?? 0
        let height = page.height ?? 0
        let source = page.sourceStillBytes ?? 0
        let jpeg = page.jpegBytes ?? 0
        let memory = page.memoryBytesAfterPage.map {
            String(format: "%.1f", Double($0) / 1_048_576)
        } ?? "?"
        let peak = page.memoryBytesPeakPage.map {
            String(format: "%.1f", Double($0) / 1_048_576)
        } ?? "?"
        return "\(width)×\(height) px · source \(source) B · JPEG \(jpeg) B · after \(memory) MiB · peak \(peak) MiB"
    }

    /// Intentionally excludes PHAsset IDs, timestamps, images and hashes.
    private func diagnostics(for job: ProcessingJob) -> String {
        let inventory = try? JobStore.outputInventory(in: job)
        return (["Lecture Asset S01; pages=\(job.totalCount); completed=\(job.completedCount); " +
                 "jpeg_files=\(inventory?.jpegCount ?? -1); motion_audio_files=\(inventory?.motionAudioCount ?? -1)"] +
         job.pages.filter { $0.phase == .completed }.map { page in
            "page=\(page.pageIndex), live=\(page.isLivePhoto), " +
            "pixels=\(page.width ?? 0)x\(page.height ?? 0), " +
            "source_bytes=\(page.sourceStillBytes ?? 0), jpeg_bytes=\(page.jpegBytes ?? 0), " +
            "memory_mib=\(page.memoryBytesAfterPage.map { String(format: "%.1f", Double($0) / 1_048_576) } ?? "unknown"), " +
            "peak_mib=\(page.memoryBytesPeakPage.map { String(format: "%.1f", Double($0) / 1_048_576) } ?? "unknown")"
         }).joined(separator: "\n")
    }
}

private struct CompanionPDFPreview: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            PDFDocumentView(url: url)
                .navigationTitle("archive.previewPDF")
                .toolbar { Button("common.done") { dismiss() } }
        }
    }
}

private struct PDFDocumentView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.document = PDFDocument(url: url)
        return view
    }
    func updateUIView(_ uiView: PDFView, context: Context) {}
}

private struct CanonicalPagePreview: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    @State private var image: UIImage?
    @State private var zoom: CGFloat = 1
    @State private var committedZoom: CGFloat = 1

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical]) {
                    if let image {
                        let fittedHeight = geometry.size.width * image.size.height / image.size.width
                        Image(uiImage: image)
                            .resizable()
                            .interpolation(.high)
                            .frame(width: geometry.size.width * zoom, height: fittedHeight * zoom)
                            .gesture(MagnifyGesture()
                                .onChanged { value in
                                    zoom = min(8, max(1, committedZoom * value.magnification))
                                }
                                .onEnded { _ in committedZoom = zoom })
                    } else {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("processing.preview")
            .toolbar { Button("common.done") { dismiss() } }
        }
        .onAppear { image = UIImage(contentsOfFile: url.path) }
        .onDisappear { image = nil }
    }
}
