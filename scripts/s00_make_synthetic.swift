// Synthetic images for S00 simulator smoke only. Never reads the user's library.
import AppKit
import Foundation

guard CommandLine.arguments.count == 2 else {
    fatalError("Usage: swift scripts/s00_make_synthetic.swift OUTPUT_DIRECTORY")
}

let output = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)

for number in 1...48 {
    let image = NSImage(size: NSSize(width: 240, height: 240))
    image.lockFocus()
    let hue = CGFloat(number % 12) / 12
    NSColor(calibratedHue: hue, saturation: 0.6, brightness: 0.8, alpha: 1).setFill()
    NSRectFill(NSRect(x: 0, y: 0, width: 240, height: 240))
    let label = String(format: "%02d", number) as NSString
    label.draw(at: NSPoint(x: 75, y: 90), withAttributes: [
        .font: NSFont.boldSystemFont(ofSize: 68),
        .foregroundColor: NSColor.white
    ])
    image.unlockFocus()
    guard let tiff = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiff),
          let jpeg = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.85]) else {
        fatalError("Could not render synthetic image \(number)")
    }
    try jpeg.write(to: output.appendingPathComponent(String(format: "%02d.jpg", number)))
}

print("Created 48 numbered synthetic JPEGs for simulator smoke")
