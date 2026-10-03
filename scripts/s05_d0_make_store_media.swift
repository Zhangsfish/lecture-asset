// Synthetic lecture-slide media used only for S05-D0 App Store screenshots.
// No user photos, network calls, or production app behavior are involved.
import AppKit
import Foundation

guard CommandLine.arguments.count == 2 else {
    fatalError("Usage: swift scripts/s05_d0_make_store_media.swift OUTPUT_DIRECTORY")
}

let output = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)

let size = NSSize(width: 1920, height: 1080)
let titles = [
    "AI 与学习", "从照片到资料", "信息检索", "知识工作流",
    "实验设计", "数据与证据", "关键结论", "下一步",
    "注意力与记忆", "研究方法", "模型与现实", "开放问题"
]
let subtitles = [
    "示例讲座 · 公开测试素材",
    "把低频信息变成可再次使用的资料",
    "先找到，再回到原始视觉证据",
    "输入 → 整理 → 保存 → 后续处理"
]

func text(_ value: String, at point: NSPoint, font: NSFont, color: NSColor = .labelColor) {
    (value as NSString).draw(at: point, withAttributes: [
        .font: font,
        .foregroundColor: color
    ])
}

func fill(_ rect: NSRect, color: NSColor, radius: CGFloat = 0) {
    color.setFill()
    if radius > 0 {
        NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
    } else {
        NSBezierPath(rect: rect).fill()
    }
}

for index in 0..<24 {
    let image = NSImage(size: size)
    image.lockFocus()

    fill(NSRect(origin: .zero, size: size), color: NSColor(calibratedWhite: 0.97, alpha: 1))
    fill(NSRect(x: 0, y: 0, width: 28, height: 1080),
         color: NSColor(calibratedRed: 0.12, green: 0.43, blue: 0.84, alpha: 1))

    let title = titles[index % titles.count]
    text(title, at: NSPoint(x: 120, y: 860),
         font: NSFont.boldSystemFont(ofSize: 82),
         color: NSColor(calibratedWhite: 0.10, alpha: 1))
    text(subtitles[index % subtitles.count], at: NSPoint(x: 124, y: 780),
         font: NSFont.systemFont(ofSize: 34),
         color: NSColor(calibratedWhite: 0.38, alpha: 1))

    if index % 3 == 0 {
        let values: [CGFloat] = [0.42, 0.70, 0.56, 0.84]
        for (j, value) in values.enumerated() {
            let x = 170 + CGFloat(j) * 310
            fill(NSRect(x: x, y: 250, width: 190, height: 430 * value),
                 color: NSColor(calibratedRed: 0.18 + CGFloat(j) * 0.05,
                                green: 0.48 + CGFloat(j) * 0.03,
                                blue: 0.82 - CGFloat(j) * 0.06,
                                alpha: 1),
                 radius: 24)
        }
        text("证据", at: NSPoint(x: 170, y: 170), font: NSFont.systemFont(ofSize: 32))
        text("结构", at: NSPoint(x: 480, y: 170), font: NSFont.systemFont(ofSize: 32))
        text("反馈", at: NSPoint(x: 790, y: 170), font: NSFont.systemFont(ofSize: 32))
        text("行动", at: NSPoint(x: 1100, y: 170), font: NSFont.systemFont(ofSize: 32))
    } else if index % 3 == 1 {
        let labels = ["原始图片", "顺序与索引", "可浏览 PDF", "可交给 AI"]
        for j in 0..<4 {
            let x = 120 + CGFloat(j) * 430
            fill(NSRect(x: x, y: 340, width: 350, height: 230),
                 color: NSColor(calibratedWhite: 0.90 - CGFloat(j) * 0.025, alpha: 1),
                 radius: 34)
            text(labels[j], at: NSPoint(x: x + 42, y: 440),
                 font: NSFont.boldSystemFont(ofSize: 36),
                 color: NSColor(calibratedWhite: 0.18, alpha: 1))
            if j < 3 {
                text("→", at: NSPoint(x: x + 370, y: 430),
                     font: NSFont.boldSystemFont(ofSize: 54),
                     color: NSColor(calibratedWhite: 0.45, alpha: 1))
            }
        }
    } else {
        let rows = [
            ("01", "先保留原始视觉证据"),
            ("02", "OCR 只负责搜索与定位"),
            ("03", "重要结论回看图片确认")
        ]
        for (j, row) in rows.enumerated() {
            let y = 600 - CGFloat(j) * 170
            fill(NSRect(x: 130, y: y, width: 110, height: 92),
                 color: NSColor(calibratedRed: 0.12, green: 0.43, blue: 0.84, alpha: 1),
                 radius: 22)
            text(row.0, at: NSPoint(x: 156, y: y + 21),
                 font: NSFont.boldSystemFont(ofSize: 34), color: .white)
            text(row.1, at: NSPoint(x: 300, y: y + 22),
                 font: NSFont.systemFont(ofSize: 42),
                 color: NSColor(calibratedWhite: 0.18, alpha: 1))
        }
    }

    text(String(format: "%02d", index + 1),
         at: NSPoint(x: 1760, y: 70),
         font: NSFont.monospacedDigitSystemFont(ofSize: 30, weight: .medium),
         color: NSColor(calibratedWhite: 0.55, alpha: 1))

    image.unlockFocus()
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let jpeg = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.90]) else {
        fatalError("Could not render store media \(index + 1)")
    }
    try jpeg.write(to: output.appendingPathComponent(String(format: "%02d.jpg", index + 1)))
}

print("Created 24 synthetic lecture-slide JPEGs for S05-D0 screenshots")
