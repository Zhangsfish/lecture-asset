import Photos
import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var model = PhotoLibraryModel()

    var body: some View {
        NavigationStack {
            Group {
                if model.authorization == .authorized {
                    gallery
                } else {
                    permissionGate
                }
            }
            .navigationTitle("app.title")
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { model.refreshAuthorization() }
        }
    }

    private var gallery: some View {
        VStack(spacing: 0) {
            Text("selection.hint")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(8)
            PhotoGridView(model: model)
            HStack {
                Text("selection.selected") + Text(" \(model.selection.count)/200")
                Spacer()
                NavigationLink {
                    ConfirmationView(model: model)
                } label: {
                    Text("selection.confirm")
                }
                .disabled(model.selection.count == 0)
                .buttonStyle(.borderedProminent)
            }
            .padding()
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
            Text("permission.explanation")
                .multilineTextAlignment(.center)
            switch model.authorization {
            case .notDetermined:
                Button("permission.allow") { model.requestFullAccess() }
                    .buttonStyle(.borderedProminent)
            case .limited, .denied:
                Text("permission.blocked")
                    .foregroundStyle(.secondary)
                Button("permission.settings") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
                .buttonStyle(.borderedProminent)
            case .restricted:
                Text("permission.restricted")
                    .foregroundStyle(.secondary)
            case .authorized:
                EmptyView()
            @unknown default:
                Text("permission.blocked")
            }
        }
        .padding(32)
    }
}
