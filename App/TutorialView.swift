import SwiftUI

/// Decorative teaching only: no PhotoKit, processing model or export actions.
struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var scene = 0
    @State private var play = false
    private let titles = ["tutorial.select", "tutorial.order", "tutorial.generate", "tutorial.clean"]
    private let descriptions = ["tutorial.selectVoice", "tutorial.orderVoice", "tutorial.generateVoice", "tutorial.cleanVoice"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text(LocalizedStringKey(titles[scene])).font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .accessibilityIdentifier("tutorial-title")
                    if reduceMotion {
                        illustration(stage: 2)
                            .accessibilityIdentifier("tutorial-static")
                    } else {
                        PhaseAnimator([0, 1, 2], trigger: play) { stage in
                            illustration(stage: stage)
                        } animation: { _ in .easeInOut(duration: 1) }
                    }
                    HStack {
                        ForEach(0..<4) { number in
                            Circle().fill(number == scene ? Color.accentColor : Color.secondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }.accessibilityHidden(true)
                    HStack {
                        if scene > 0 {
                            Button("tutorial.previous") { changeScene(scene - 1) }
                                .buttonStyle(.bordered)
                                .accessibilityIdentifier("tutorial-previous")
                        }
                        Button(scene == 3 ? "common.done" : "tutorial.next") {
                            if scene == 3 { dismiss() } else { changeScene(scene + 1) }
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("tutorial-next")
                    }
                }.padding(24)
            }
            .navigationTitle("tutorial.title")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("tutorial.skip") { dismiss() }
                        .accessibilityIdentifier("tutorial-skip")
                }
            }
        }
        .onAppear { play.toggle() }
    }

    private func changeScene(_ next: Int) {
        scene = next
        play.toggle()
    }

    private func illustration(stage: Int) -> some View {
        Group {
            switch scene {
            case 0:
                VStack(spacing: 8) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                        ForEach(0..<16) { number in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(number < (stage == 2 ? 12 : stage == 1 ? 6 : 1) ? Color.accentColor.opacity(0.25) : Color.secondary.opacity(0.1))
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(alignment: .bottomTrailing) {
                                    if number < (stage == 2 ? 12 : stage == 1 ? 6 : 1) {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.accentColor).padding(4)
                                    }
                                }
                                .animation(reduceMotion ? nil : .easeInOut.delay(Double(number) * 0.04), value: stage)
                        }
                    }
                    Image(systemName: "hand.point.up.left.fill")
                        .font(.largeTitle)
                        .offset(x: reduceMotion ? 0 : stage == 0 ? -90 : stage == 1 ? 0 : 90)
                }
            case 1:
                VStack(spacing: 16) {
                    HStack {
                        ForEach(stage == 0 ? [3, 1, 2] : [1, 2, 3], id: \.self) { number in
                            Label("\(number)", systemImage: "photo")
                                .font(.title).padding(12)
                                .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    Image(systemName: "clock.arrow.circlepath").font(.largeTitle)
                    Image(systemName: "xmark.circle").font(.title2)
                }
            case 2:
                VStack(spacing: 24) {
                    Image(systemName: "photo.stack").font(.system(size: 50))
                    Label("tutorial.generateAction", systemImage: "hand.tap")
                        .padding(12).background(Color.accentColor.opacity(0.15), in: Capsule())
                    HStack(spacing: 32) {
                        Label("ZIP", systemImage: "doc.zipper")
                        Label("PDF", systemImage: "doc.richtext")
                    }.font(.title2).opacity(stage == 0 ? 0.2 : 1)
                }
            default:
                VStack(spacing: 18) {
                    Label("ZIP", systemImage: stage == 0 ? "square.and.arrow.up" : "checkmark.seal.fill")
                        .font(.largeTitle).foregroundStyle(stage == 0 ? Color.primary : Color.green)
                    Text("tutorial.saved").font(.headline)
                    VStack(spacing: 12) {
                        Label("tutorial.deletePhotos", systemImage: "photo.badge.minus")
                        Label("tutorial.keepPhotos", systemImage: "folder.badge.minus")
                    }.opacity(stage == 0 ? 0.2 : 1)
                }
            }
        }
        .frame(maxWidth: 340).frame(minHeight: 260)
        .padding(12)
        .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 24))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(LocalizedStringKey(descriptions[scene]))
        .gesture(DragGesture().onEnded { value in
            if value.translation.width < -40 && scene < 3 { changeScene(scene + 1) }
            if value.translation.width > 40 && scene > 0 { changeScene(scene - 1) }
        })
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
