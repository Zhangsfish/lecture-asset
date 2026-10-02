import SwiftUI

/// Static, local help. Presenting this sheet does not create or mutate a photo job.
struct AboutSupportView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("about.usageTitle") {
                    Label("about.select", systemImage: "square.grid.3x3")
                    Label("about.review", systemImage: "checkmark.circle")
                    Label("about.process", systemImage: "doc.zipper")
                    Label("about.save", systemImage: "square.and.arrow.up")
                }
                Section("about.privacyTitle") {
                    Text("about.privacyLocal")
                    Text("about.privacyShare")
                    Text("about.privacyDelete")
                    Text("about.privacyLive")
                }
                Section("about.versionTitle") {
                    Text(version)
                        .accessibilityIdentifier("about-version")
                }
            }
            .navigationTitle("about.title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("common.done") { dismiss() }
                        .accessibilityIdentifier("about-close")
                }
            }
        }
        .accessibilityIdentifier("about-view")
    }

    private var version: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "—"
        let build = info?["CFBundleVersion"] as? String ?? "—"
        return "\(version) (\(build))"
    }
}
