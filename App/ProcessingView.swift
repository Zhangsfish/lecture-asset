import SwiftUI
import UIKit

struct ProcessingView: View {
    @ObservedObject var model: ProcessingModel
    @State private var showingRemoveConfirmation = false
    @State private var pageToPreview: JobPage?
    @State private var copied = false

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
                        if job.phase == .completed {
                            Text("processing.completeDetail")
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
        .sheet(item: $pageToPreview) { page in
            if let url = model.imageURL(for: page) {
                CanonicalPagePreview(url: url)
            }
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
