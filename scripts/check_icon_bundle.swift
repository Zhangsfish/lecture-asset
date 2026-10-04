// CI-only verification of compiled icon; not part of the App target.
import Foundation
import ImageIO
import CoreGraphics

let app = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
let source = URL(fileURLWithPath: CommandLine.arguments[2])
let info = try PropertyListSerialization.propertyList(from: Data(contentsOf: app.appendingPathComponent("Info.plist")), format: nil) as! [String: Any]
precondition(info["CFBundleIdentifier"] as? String == "com.zhangsfish.lectureasset")
precondition(info["CFBundleDisplayName"] as? String == "Lecture Asset")
let icons = info["CFBundleIcons"] as! [String: Any]
precondition(icons["CFBundleAlternateIcons"] == nil)
let primary = icons["CFBundlePrimaryIcon"] as! [String: Any]
precondition(primary["CFBundleIconName"] as? String == "AppIcon")
let names = primary["CFBundleIconFiles"] as! [String]
let pngs = try FileManager.default.contentsOfDirectory(at: app, includingPropertiesForKeys: nil)
    .filter { url in url.pathExtension == "png" && names.contains { url.lastPathComponent.hasPrefix($0) } }
precondition(!pngs.isEmpty, "No compiled primary icon PNG")
precondition(FileManager.default.fileExists(atPath: app.appendingPathComponent("Assets.car").path))

func read(_ url: URL) -> CGImage {
    let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil)!
    return CGImageSourceCreateImageAtIndex(imageSource, 0, nil)!
}
func render(_ image: CGImage, _ width: Int, _ height: Int) -> [UInt8] {
    var pixels = [UInt8](repeating: 0, count: width * height * 4)
    pixels.withUnsafeMutableBytes { bytes in
        let context = CGContext(data: bytes.baseAddress, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: width * 4,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        context.interpolationQuality = .high
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
    }
    return pixels
}
let selected = read(source)
precondition(selected.width == 1024 && selected.height == 1024)
for png in pngs.sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
    let compiled = read(png)
    let actual = render(compiled, compiled.width, compiled.height)
    let expected = render(selected, compiled.width, compiled.height)
    var error = 0.0
    for i in stride(from: 0, to: actual.count, by: 4) {
        precondition(actual[i+3] == 255, "Compiled icon unexpectedly transparent")
        for c in 0..<3 { error += abs(Double(actual[i+c]) - Double(expected[i+c])) }
    }
    let meanError = error / Double(compiled.width * compiled.height * 3)
    // actool and CGContext use different downsample filters; allow small edge differences.
    precondition(meanError < 6, "Compiled icon differs from selected V1")
    print("PASS compiled \(png.lastPathComponent): \(compiled.width)x\(compiled.height), sRGB rendered RGB mean error \(String(format: "%.4f", meanError)), opaque")
}
print("PASS primary AppIcon / Assets.car / Bundle ID / App name / no alternate icons")
