import Photos
import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var model: PhotoLibraryModel
    @StateObject private var processor: ProcessingModel
    @State private var showingAbout = false
    @State private var showingTutorial = false
    @State private var firstVisit: Bool

    init() {
        // Reserve first visit before ProcessingModel restores any private job.
        _firstVisit = State(initialValue: TutorialVisitStore.reserveFirstVisit())
        _model = StateObject(wrappedValue: PhotoLibraryModel())
        _processor = StateObject(wrappedValue: ProcessingModel())
    }

    var body: some View {
        NavigationStack {
            Group {
                if processor.isRestoring {
                    ProgressView()
                } else if processor.job != nil {
                    ProcessingView(model: processor)
                } else if processor.storageFailed {
                    Text("processing.storageFailed").padding()
                } else if model.authorization == .authorized {
                    gallery
                } else {
                    permissionGate
                }
            }
            .navigationTitle("app.title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("about.title", systemImage: "info.circle") { showingAbout = true }
                        .accessibilityIdentifier("about-open")
                }
            }
        }
        .sheet(isPresented: $showingAbout) { AboutSupportView() }
        .sheet(isPresented: $showingTutorial) { TutorialView() }
        .task(id: processor.isRestoring) {
            guard !processor.isRestoring, firstVisit else { return }
            firstVisit = false
            showingTutorial = processor.job == nil && !processor.storageFailed && model.authorization == .notDetermined
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { model.refreshAuthorization() }
            if phase == .background { processor.pauseAfterCurrentPage() }
        }
    }

    private var gallery: some View {
        VStack(spacing: 0) {
            Text("selection.hint")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(8)
            PhotoGridView(model: model)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                (Text("selection.selected") + Text(" \(model.selection.count)/200"))
                    .font(.subheadline.monospacedDigit())
                    .frame(maxWidth: .infinity, alignment: .leading)
                NavigationLink {
                    ConfirmationView(model: model, processor: processor)
                } label: {
                    Text("selection.confirm")
                        .frame(maxWidth: .infinity)
                }
                .disabled(model.selection.count == 0)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .accessibilityIdentifier("selection-confirm")
            }
            .padding()
            .background(.regularMaterial)
        }
        .overlay(alignment: .top) {
            if model.showsSelectionLimit {
                Text("selection.limit")
                    .padding(12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .padding()
                    .onTapGesture { model.showsSelectionLimit = false }
                    .accessibilityAddTraits(.isStaticText)
            }
        }
        .onChange(of: model.showsSelectionLimit) { _, visible in
            if visible {
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(3))
                    model.showsSelectionLimit = false
                }
            }
        }
    }

    private var permissionGate: some View {
        VStack(spacing: 18) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 50))
            Text("permission.title")
                .font(.title2.bold())
            Text(model.authorization == .notDetermined ? "permission.explanation" :
                 model.authorization == .restricted ? "permission.restricted" : "permission.blocked")
                .multilineTextAlignment(.center)
            switch model.authorization {
            case .notDetermined:
                Button("permission.allow") { model.requestFullAccess() }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("permission-allow")
            case .limited, .denied:
                Button("permission.settings") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
                .buttonStyle(.borderedProminent)
            case .restricted:
                EmptyView()
            case .authorized:
                EmptyView()
            @unknown default:
                Text("permission.blocked")
            }
        }
        .padding(32)
    }
}
