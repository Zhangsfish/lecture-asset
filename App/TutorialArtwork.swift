import SwiftUI

/// One local, deterministic drawing vocabulary. No Photos, share, URL or AI actions.
/// The same time-addressable artwork serves live playback, Reduce Motion and
/// native storyboard tests. Coordinates use a 340 × 390 design canvas.
struct TutorialArtwork: View {
    let scene: Int
    let time: Double
    static let duration = 3.4
    private let ink = Color(red: 0.15, green: 0.30, blue: 0.80)
    private let mint = Color(red: 0.18, green: 0.57, blue: 0.43)

    var body: some View {
        ZStack {
            Ellipse().fill(ink.opacity(0.035)).frame(width: 300, height: 240)
                .blur(radius: 30).position(x: 170, y: 210)
            switch scene {
            case 0: selection
            case 1: order
            case 2: generation
            case 3: cleanup
            default: handoff
            }
        }
        .frame(width: 340, height: 390)
        .allowsHitTesting(false)
    }

    private func progress(_ start: Double, _ end: Double) -> CGFloat {
        let x = CGFloat(min(1, max(0, (time - start) / (end - start))))
        return x * x * (3 - 2 * x)
    }

    private func shown(_ start: Double) -> Double { Double(progress(start, start + 0.24)) }

    private var selection: some View {
        ZStack {
            ForEach(0..<16) { index in
                let threshold = 0.68 + Double(index - 4) * 0.18
                let selected = index >= 4 && index <= 11 ? progress(threshold, threshold + 0.2) : 0
                let x = CGFloat(index % 4) * 78 + 53
                let y = CGFloat(index / 4) * 78 + 70
                SlideCard(variant: index, selected: selected).frame(width: 68, height: 68)
                    .scaleEffect(1 + 0.045 * selected).offset(y: -3 * selected)
                    .position(x: x, y: y)
            }
            let swipe = progress(0.68, 2.12)
            // A soft S curve follows row two, turns, and returns along row three.
            let x = swipe < 0.5 ? 53 + 234 * swipe * 2 : 287 - 234 * (swipe - 0.5) * 2
            let y = 148 + 78 * progress(1.26, 1.54)
            Circle().stroke(ink.opacity(0.30 * (1 - Double(progress(0.65, 1)))), lineWidth: 2)
                .frame(width: 36 + 22 * progress(0.45, 0.65), height: 36 + 22 * progress(0.45, 0.65))
                .position(x: 53, y: 148).opacity(shown(0.35))
            Text("tutorial.hold").font(.system(size: 12, weight: .semibold))
                .foregroundStyle(ink).padding(.horizontal, 10).padding(.vertical, 5)
                .background(.background, in: Capsule())
                .position(x: 63, y: 115).opacity(shown(0.30) * (1 - shown(0.70)))
            TouchHand().fill(.white).overlay(TouchHand().stroke(ink, lineWidth: 1.7))
                .frame(width: 34, height: 48)
                .shadow(color: ink.opacity(0.22), radius: 6, y: 4)
                .scaleEffect(1 - 0.10 * progress(0.35, 0.45) + 0.10 * progress(0.65, 0.75))
                .position(x: x + 8, y: y + 22 - 30 * (1 - progress(0, 0.35)))
                .opacity(shown(0) * (1 - shown(2.4)))
        }
    }

    private var order: some View {
        ZStack {
            ForEach(0..<4) { index in
                let snap = progress(0.45 + Double(index) * 0.10, 1.35 + Double(index) * 0.10)
                let originY: [CGFloat] = [210, 65, 140, 286]
                let finalY = CGFloat(index) * 78 + 76
                let removed = index == 3 ? progress(2.0, 2.5) : 0
                HStack(spacing: 16) {
                    SlideCard(variant: index + 2, selected: 0).frame(width: 112, height: 72)
                    VStack(alignment: .leading, spacing: 7) {
                        Text(index == 3 ? "×" : "0\(index + 1)")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundStyle(index == 3 ? Color.secondary : ink)
                        Text(["09:00", "09:02", "09:04", "×"][index])
                            .font(.system(size: 11, weight: .medium, design: .monospaced)).foregroundStyle(.secondary)
                    }
                }
                .padding(10).frame(width: 230)
                .background(.background, in: RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.07), radius: 12, y: 6)
                .rotationEffect(.degrees(Double(1 - snap) * [8, -7, 4, -5][index]))
                .offset(x: -removed * 90)
                .position(x: 170 + (1 - snap) * (index % 2 == 0 ? 16 : -16),
                          y: originY[index] + (finalY - originY[index]) * snap)
                .opacity((1 - Double(removed)) * shown(Double(index) * 0.08))
                .scaleEffect(1 - 0.12 * removed)
            }
            TouchHand().fill(.white).overlay(TouchHand().stroke(ink, lineWidth: 1.7))
                .frame(width: 28, height: 40).position(x: 222, y: 315)
                .opacity(shown(1.65) * (1 - shown(2.15)))
        }
    }

    private var generation: some View {
        ZStack {
            let compress = progress(0.55, 1.15)
            ForEach(0..<3) { index in
                SlideCard(variant: index, selected: 0).frame(width: 134, height: 98)
                    .rotationEffect(.degrees(Double(index - 1) * 7 * Double(1 - compress)))
                    .scaleEffect(1 - 0.5 * compress)
                    .position(x: 170 + CGFloat(index - 1) * 14 * (1 - compress), y: 87 + compress * 70)
                    .opacity(1 - Double(progress(1.3, 1.65)))
            }
            Text("tutorial.generateAction").font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white).padding(.horizontal, 18).padding(.vertical, 12)
                .background(ink, in: Capsule()).scaleEffect(1 - 0.06 * progress(0.3, 0.5))
                .position(x: 170, y: 180).opacity(1 - shown(0.9))
            TouchHand().fill(.white).overlay(TouchHand().stroke(ink, lineWidth: 1.7))
                .frame(width: 28, height: 40).position(x: 199, y: 203)
                .opacity(shown(0.1) * (1 - shown(0.8)))
            VStack(alignment: .leading, spacing: 7) {
                ForEach(0..<4) { index in
                    Capsule().fill(ink.opacity(0.4)).frame(width: CGFloat(65 - index * 9), height: 3)
                }
            }.padding(24).background(.background, in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: ink.opacity(0.12), radius: 16, y: 6)
                .scaleEffect(0.7 + 0.3 * progress(0.9, 1.3))
                .position(x: 170, y: 150).opacity(shown(0.9) * (1 - shown(1.9)))
            let split = progress(1.65, 2.45)
            FileCard(kind: "ZIP", tint: ink).frame(width: 120, height: 156)
                .rotationEffect(.degrees(-5 * Double(split)))
                .position(x: 170 - 77 * split, y: 180 + 63 * split).opacity(shown(1.65))
            FileCard(kind: "PDF", tint: mint).frame(width: 120, height: 156)
                .rotationEffect(.degrees(5 * Double(split)))
                .position(x: 170 + 77 * split, y: 180 + 63 * split).opacity(shown(1.8))
        }
    }

    private var cleanup: some View {
        ZStack {
            let save = progress(0.3, 1.15)
            FolderShape().fill(ink.opacity(0.12)).frame(width: 172, height: 112).position(x: 184, y: 114)
            FileCard(kind: "ZIP", tint: ink).frame(width: 88, height: 110)
                .scaleEffect(1 - 0.42 * save)
                .rotationEffect(.degrees(-8 * Double(1 - save)))
                .position(x: 70 + 114 * save, y: 96 + 12 * save)
            FolderShape().fill(LinearGradient(colors: [ink.opacity(0.8), ink], startPoint: .top, endPoint: .bottom))
                .frame(width: 174, height: 102).position(x: 184, y: 148)
            Text("tutorial.files").font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                .position(x: 184, y: 157)
            HStack(spacing: 7) {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(mint)
                Text("tutorial.confirmSaved").font(.system(size: 13, weight: .semibold))
            }.padding(10).background(.background, in: Capsule())
                .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
                .position(x: 184, y: 213).opacity(shown(1.25))
            VStack(spacing: 12) {
                cleanupChoice("tutorial.deletePhotos", symbol: "trash", tint: .secondary)
                cleanupChoice("tutorial.keepPhotos", symbol: "photo", tint: mint)
            }.frame(width: 286).position(x: 170, y: 313 + 12 * (1 - progress(1.8, 2.4)))
                .opacity(shown(1.8))
        }
    }

    private func cleanupChoice(_ key: String, symbol: String, tint: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol).foregroundStyle(tint).frame(width: 24)
            Text(LocalizedStringKey(key)).font(.system(size: 12, weight: .medium)).fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }.padding(14).frame(minHeight: 52)
            .background(.background, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 9, y: 4)
    }

    private var handoff: some View {
        ZStack {
            FileCard(kind: "ZIP", tint: ink).frame(width: 66, height: 82)
                .rotationEffect(.degrees(-6 * Double(1 - progress(0.8, 1.3))))
                .position(x: 76 + 29 * progress(0.8, 1.3), y: 70 + 21 * progress(0.8, 1.3))
            VStack(spacing: 12) {
                Capsule().fill(Color.secondary.opacity(0.25)).frame(width: 28, height: 3)
                HStack(spacing: 20) {
                    ForEach(0..<3) { index in
                        RoundedRectangle(cornerRadius: 12).fill(index == 1 ? ink.opacity(0.15) : Color.secondary.opacity(0.08))
                            .frame(width: 40, height: 38)
                            .overlay { if index == 1 { Text("AI").font(.system(size: 14, weight: .bold)).foregroundStyle(ink) } }
                    }
                }
            }.padding(16).background(.background, in: RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.10), radius: 16, y: 8)
                .position(x: 170, y: 190 - 57 * progress(0.25, 0.65))
                .opacity(shown(0.25) * (1 - shown(1.15)))
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("AI").font(.system(size: 14, weight: .bold)).foregroundStyle(ink)
                    Spacer()
                    Text("tutorial.example").font(.system(size: 10)).foregroundStyle(.secondary)
                }
                HStack { Spacer(); Text("tutorial.aiPrompt").font(.system(size: 13, weight: .medium))
                        .padding(12).background(ink.opacity(0.09), in: RoundedRectangle(cornerRadius: 14)) }
                    .opacity(shown(1.65))
                VStack(alignment: .leading, spacing: 15) {
                    Text("tutorial.aiResult").font(.system(size: 17, weight: .semibold))
                    ForEach(1..<4) { number in
                        HStack(spacing: 10) {
                            Text("0\(number)").font(.system(size: 12, weight: .medium, design: .monospaced)).foregroundStyle(ink)
                            Capsule().fill(Color.primary.opacity(0.15)).frame(width: CGFloat(126 - number * 10), height: 4)
                        }.opacity(shown(2.05 + Double(number) * 0.13))
                    }
                }.padding(16).frame(maxWidth: .infinity, alignment: .leading)
                    .background(ink.opacity(0.035), in: RoundedRectangle(cornerRadius: 16)).opacity(shown(2))
            }.padding(20).frame(width: 284, height: 286)
                .background(.background, in: RoundedRectangle(cornerRadius: 22))
                .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
                .position(x: 170, y: 214 + 12 * (1 - progress(1.15, 1.55))).opacity(shown(1.15))
            // Saved attachment above the chat; foreground keeps the handoff object visible.
            FileCard(kind: "ZIP", tint: ink).frame(width: 42, height: 52)
                .position(x: 98, y: 70).opacity(shown(1.15))
        }
    }
}

private struct SlideCard: View {
    let variant: Int
    let selected: CGFloat
    private let tones: [Color] = [Color(red: 0.15, green: 0.30, blue: 0.8),
                                 Color(red: 0.18, green: 0.57, blue: 0.43),
                                 Color(red: 0.77, green: 0.47, blue: 0.18)]
    var body: some View {
        Canvas { context, size in
            let color = tones[variant % tones.count]
            let bounds = CGRect(origin: .zero, size: size)
            context.fill(Path(roundedRect: bounds, cornerRadius: 10), with: .color(Color(.systemBackground)))
            context.fill(Path(CGRect(x: size.width * 0.13, y: size.height * 0.16, width: size.width * 0.62, height: 4)), with: .color(color))
            for row in 0..<3 {
                context.fill(Path(CGRect(x: size.width * 0.13, y: size.height * 0.30 + CGFloat(row) * 5,
                                         width: size.width * (row == 2 ? 0.44 : 0.72), height: 2)), with: .color(.secondary.opacity(0.22)))
            }
            if variant % 2 == 0 {
                for bar in 0..<4 {
                    let height = size.height * CGFloat(bar + 2) / 15
                    let rect = CGRect(x: size.width * (0.15 + CGFloat(bar) * 0.18), y: size.height * 0.85 - height,
                                      width: size.width * 0.10, height: height)
                    context.fill(Path(roundedRect: rect, cornerRadius: 2), with: .color(color.opacity(0.35 + Double(bar) * 0.12)))
                }
            } else {
                let ellipse = CGRect(x: size.width * 0.22, y: size.height * 0.56, width: size.width * 0.30, height: size.height * 0.28)
                context.stroke(Path(ellipseIn: ellipse), with: .color(color.opacity(0.65)), lineWidth: 2)
                context.fill(Path(ellipseIn: ellipse.offsetBy(dx: size.width * 0.20, dy: 0)), with: .color(color.opacity(0.16)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(Double(selected)), lineWidth: 2))
        .shadow(color: .black.opacity(0.09), radius: 6, y: 3)
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: "checkmark.circle.fill").font(.system(size: 18)).foregroundStyle(.white, Color.blue)
                .scaleEffect(0.7 + 0.3 * selected).opacity(Double(selected)).padding(4)
        }
    }
}

private struct FileCard: View {
    let kind: String
    let tint: Color
    var body: some View {
        GeometryReader { geometry in
            let w = geometry.size.width
            let h = geometry.size.height
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground))
                Path { path in
                    path.move(to: CGPoint(x: w - 27, y: 0)); path.addLine(to: CGPoint(x: w - 27, y: 23))
                    path.addQuadCurve(to: CGPoint(x: w, y: 27), control: CGPoint(x: w - 27, y: 30))
                }.stroke(tint.opacity(0.25), lineWidth: 1.5)
                RoundedRectangle(cornerRadius: 4).fill(tint.opacity(0.14))
                    .frame(width: w * 0.5, height: h * 0.30).position(x: w * 0.4, y: h * 0.36)
                if kind == "ZIP" {
                    VStack(spacing: 3) { ForEach(0..<4) { _ in RoundedRectangle(cornerRadius: 1).fill(tint).frame(width: 6, height: 4) } }
                        .position(x: w * 0.4, y: h * 0.36)
                } else {
                    VStack(alignment: .leading, spacing: 4) { ForEach(0..<3) { index in Capsule().fill(tint.opacity(0.65)).frame(width: w * (index == 2 ? 0.2 : 0.32), height: 2) } }
                        .position(x: w * 0.4, y: h * 0.36)
                }
                Text(kind).font(.system(size: max(10, w * 0.16), weight: .bold, design: .rounded)).foregroundStyle(tint)
                    .position(x: w * 0.38, y: h * 0.72)
            }.overlay(RoundedRectangle(cornerRadius: 16).stroke(tint.opacity(0.13)))
                .shadow(color: tint.opacity(0.15), radius: 12, y: 6)
        }
    }
}

private struct FolderShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 0.2))
        path.addLine(to: CGPoint(x: 0, y: 8))
        path.addQuadCurve(to: CGPoint(x: 8, y: 0), control: .zero)
        path.addLine(to: CGPoint(x: rect.width * 0.36, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 0.47, y: rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.width - 10, y: rect.height * 0.15))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height * 0.25), control: CGPoint(x: rect.width, y: rect.height * 0.15))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 10))
        path.addQuadCurve(to: CGPoint(x: rect.width - 10, y: rect.height), control: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 10, y: rect.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.height - 10), control: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

private struct TouchHand: Shape {
    func path(in rect: CGRect) -> Path {
        // Tip at top left, with a short raised finger and three curled fingers.
        var path = Path()
        path.move(to: CGPoint(x: 5, y: 29))
        path.addLine(to: CGPoint(x: 5, y: 5))
        path.addQuadCurve(to: CGPoint(x: 14, y: 5), control: CGPoint(x: 9, y: -3))
        path.addLine(to: CGPoint(x: 14, y: 20))
        path.addCurve(to: CGPoint(x: 31, y: 26), control1: CGPoint(x: 20, y: 15), control2: CGPoint(x: 33, y: 19))
        path.addLine(to: CGPoint(x: 29, y: 41))
        path.addQuadCurve(to: CGPoint(x: 15, y: 46), control: CGPoint(x: 25, y: 49))
        path.addLine(to: CGPoint(x: 1, y: 32))
        path.addQuadCurve(to: CGPoint(x: 5, y: 29), control: CGPoint(x: -3, y: 25))
        path.closeSubpath()
        return path
    }
}
