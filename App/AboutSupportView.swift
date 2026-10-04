import SwiftUI
import UIKit

/// Static, local help. Presenting this sheet does not create or mutate a photo job.
struct AboutSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var showingTutorial = false
    @State private var emailCopied = false

    var body: some View {
        NavigationStack {
            Form {
                Section("about.usageTitle") {
                    Button("tutorial.replay", systemImage: "play.circle") { showingTutorial = true }
                        .accessibilityIdentifier("tutorial-replay")
                    Label("about.select", systemImage: "square.grid.3x3")
                    Label("about.review", systemImage: "checkmark.circle")
                    Label("about.process", systemImage: "doc.zipper")
                    Label("about.save", systemImage: "square.and.arrow.up")
                }
                Section("about.contactTitle") {
                    Button { openURL(URL(string: "mailto:zhangs.taq@gmail.com")!) } label: {
                        Label { Text(verbatim: "zhangs.taq@gmail.com") } icon: {
                            Image(systemName: "envelope")
                        }
                    }.accessibilityIdentifier("about-email")
                    Button(emailCopied ? "about.emailCopied" : "about.copyEmail", systemImage: "doc.on.doc") {
                        UIPasteboard.general.string = "zhangs.taq@gmail.com"
                        emailCopied = true
                    }.accessibilityIdentifier("about-copy-email")
                    Button { openURL(URL(string: "https://zhang-shuo-portfolio.vercel.app/")!) } label: {
                        Label("about.homepage", systemImage: "arrow.up.right.square")
                    }.accessibilityIdentifier("about-homepage")
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
        .sheet(isPresented: $showingTutorial) { TutorialView() }
    }

    private var version: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "—"
        let build = info?["CFBundleVersion"] as? String ?? "—"
        return "\(version) (\(build))"
    }
}
