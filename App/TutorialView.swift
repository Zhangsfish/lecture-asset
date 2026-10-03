import SwiftUI

/// Teaching only. Job restoration, Photos permission and export state live outside this view.
struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var scene = 0
    static let titles = ["tutorial.select", "tutorial.order", "tutorial.generate", "tutorial.clean", "tutorial.ai"]
    static let descriptions = ["tutorial.selectVoice", "tutorial.orderVoice", "tutorial.generateVoice", "tutorial.cleanVoice", "tutorial.aiVoice"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    Text(LocalizedStringKey(Self.titles[scene])).font(.title2.bold())
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("tutorial-title")
                    GeometryReader { geometry in
                        Group {
                            if reduceMotion {
                                TutorialArtwork(scene: scene, time: TutorialArtwork.duration)
                            } else {
                                TutorialPlayback(scene: scene).id(scene)
                            }
                        }
                            .scaleEffect(min(1, geometry.size.width / 340), anchor: .top)
                            .frame(width: geometry.size.width, height: 390, alignment: .top)
                    }.frame(height: 390)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(LocalizedStringKey(Self.descriptions[scene]))
                        .accessibilityIdentifier(reduceMotion ? "tutorial-static" : "tutorial-artwork")
                        .contentShape(Rectangle())
                        .gesture(DragGesture().onEnded { value in
                            if value.translation.width < -40 && scene < Self.titles.count - 1 { scene += 1 }
                            if value.translation.width > 40 && scene > 0 { scene -= 1 }
                        })
                    HStack(spacing: 8) {
                        ForEach(Self.titles.indices, id: \.self) { number in
                            Capsule().fill(number == scene ? Color.accentColor : Color.secondary.opacity(0.25))
                                .frame(width: number == scene ? 20 : 6, height: 6)
                        }
                    }.accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text("\(scene + 1) / \(Self.titles.count)"))
                        .accessibilityIdentifier("tutorial-page")
                }.padding(.horizontal, 24).padding(.top, 24).padding(.bottom, 18)
            }
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 16) {
                    if scene > 0 {
                        Button("tutorial.previous") { scene -= 1 }
                            .buttonStyle(.bordered).accessibilityIdentifier("tutorial-previous")
                    }
                    Button(scene == Self.titles.count - 1 ? "common.done" : "tutorial.next") {
                        if scene == Self.titles.count - 1 { dismiss() } else { scene += 1 }
                    }.buttonStyle(.borderedProminent).accessibilityIdentifier("tutorial-next")
                }.frame(maxWidth: .infinity).padding(16).background(.regularMaterial)
            }
            .navigationTitle("tutorial.title").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("tutorial.skip") { dismiss() }.accessibilityIdentifier("tutorial-skip")
                }
            }
        }
    }
}

/// Plays once per scene, then stops scheduling frames. Skip and navigation never
/// wait for playback. Disappearing cancels the sleep; no processing state is touched.
private struct TutorialPlayback: View {
    let scene: Int
    @State private var start = Date()
    @State private var settled = false

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: settled)) { context in
            TutorialArtwork(scene: scene, time: settled ? TutorialArtwork.duration :
                min(TutorialArtwork.duration, max(0, context.date.timeIntervalSince(start))))
        }
        .task {
            start = Date()
            settled = false
            do { try await Task.sleep(for: .seconds(TutorialArtwork.duration)) }
            catch { return }
            settled = true
        }
    }
}

/// Capture before JobStore's restoration creates its root. Existing installations
/// already have that directory, including after a job has been purged.
enum TutorialVisitStore {
    static func reserveFirstVisit(at directory: URL? = nil) -> Bool {
        guard let root = directory ?? FileManager.default.urls(for: .applicationSupportDirectory,
                                                               in: .userDomainMask).first?.appending(path: "LectureAsset")
        else { return false }
        guard !FileManager.default.fileExists(atPath: root.path) else { return false }
        do {
            try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
            try Data("tutorial-v1".utf8).write(to: root.appending(path: "tutorial-visit"), options: .atomic)
            return true
        } catch { return false }
    }
}
