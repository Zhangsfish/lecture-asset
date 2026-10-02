import SwiftUI
import UIKit
import PDFKit

struct ProcessingView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var model: ProcessingModel
    @State private var showingRemoveConfirmation = false
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
                        if job.phase != .completed || archive.state?.jobId != job.id {
                            Text(phaseKey(for: job.phase)).font(.title2.bold())
                                .accessibilityIdentifier("processing-phase")
                        }
                        if job.phase != .completed {
                            ProgressView(value: Double(job.completedCount), total: Double(job.totalCount))
                            HStack {
                                Text("processing.current")
                                Text("\(job.failedPage?.pageIndex ?? job.nextPage?.pageIndex ?? job.totalCount) / \(job.totalCount)")
                            }
                            .accessibilityIdentifier("processing-progress")
                        }

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
                            if let archiveState = archive.state, archiveState.jobId == job.id {
                                Text(archiveKey(for: archiveState.phase))
                                    .font(.title2.bold())
                                    .accessibilityIdentifier("archive-phase")
                                if archiveState.phase == .processing {
                                    Text("archive.processingDetail")
                                    ProgressView(value: Double(archiveState.completedOCRCount),
                                                 total: Double(job.totalCount))
                                    Text("\(archiveState.completedOCRCount) / \(job.totalCount)")
                                        .font(.footnote.monospacedDigit())
                                        .accessibilityIdentifier("archive-progress")
                                }
                                if archiveState.phase == .failed {
                                    Text("archive.failedDetail").foregroundStyle(.red)
                                    DisclosureGroup("archive.technicalDetails") {
                                        Text(archive.safeFailureDiagnostics(job: job))
                                            .font(.caption.monospaced())
                                            .textSelection(.enabled)
                                            .accessibilityIdentifier("archive-safe-failure")
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
                                    if archiveState.zipShareReceipt?.externalSaveConfirmed == true,
                                       let summary = archive.deletionSummary {
                                        Button(role: .destructive) {
                                            Task {
                                                pendingDeleteSummary = await archive.refreshDeletionEligibility(job: job)
                                                showingDeleteConfirmation = pendingDeleteSummary != nil
                                            }
                                        } label: {
                                            Text("export.deleteSources") + Text(" \(summary.count)")
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(.red)
                                        .disabled(archive.exportBusy)
                                        .accessibilityIdentifier("export-delete-sources")
                                    } else if archiveState.zipShareReceipt?.reportedCompleted == true,
                                              archiveState.zipShareReceipt?.externalSaveConfirmed != true {
                                        Button("export.confirmSaved") { showingSaveConfirmation = true }
                                            .buttonStyle(.borderedProminent)
                                            .disabled(archive.exportBusy)
                                            .accessibilityIdentifier("export-confirm-saved")
                                    } else if archiveState.zipShareReceipt?.externalSaveConfirmed != true {
                                        Button("export.shareZIP") {
                                            Task { presentedShare = await archive.prepareShare(kind: .zip, job: job) }
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .disabled(archive.exportBusy)
                                        .accessibilityIdentifier("export-share-zip")
                                    }
                                    if archiveState.zipShareReceipt?.externalSaveConfirmed == true {
                                        if archive.deletionSummary == nil {
                                            Text("export.cleanupLockedHint")
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Divider()
                                    if archiveState.zipShareReceipt?.reportedCompleted == true {
                                        Button("export.shareZIP") {
                                            Task { presentedShare = await archive.prepareShare(kind: .zip, job: job) }
                                        }
                                        .disabled(archive.exportBusy)
                                        .accessibilityIdentifier("export-share-zip")
                                    }
                                    Button("archive.previewPDF") { showingPDF = true }
                                    Button("export.sharePDF") {
                                        Task { presentedShare = await archive.prepareShare(kind: .pdf, job: job) }
                                    }
                                    .disabled(archive.exportBusy)
                                    .accessibilityIdentifier("export-share-pdf")
                                }
                            } else if !archive.isBusy {
                                Text("processing.completeDetail")
                                Button("archive.start") { archive.startOrRetry(job: job) }
                                    .buttonStyle(.borderedProminent)
                                    .accessibilityIdentifier("archive-start")
                            }
                        }

                        if let error = archive.exportError {
                            Text(exportErrorKey(for: error)).foregroundStyle(.red)
                                .accessibilityIdentifier("export-error")
                        }
                        if archive.exportBusy { ProgressView("export.busy") }

                        if job.phase != .processing && job.sourcesDeleted != true {
                            Divider()
                            Button("export.discardWorkCopy") {
                                showingDiscardConfirmation = true
                            }
                            .buttonStyle(.bordered)
                            .disabled(archive.isBusy || archive.exportBusy)
                            .accessibilityIdentifier("export-discard-work")
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(model.job?.phase == .completed ? "" : "processing.title")
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
