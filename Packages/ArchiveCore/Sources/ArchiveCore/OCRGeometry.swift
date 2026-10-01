import Foundation

/// Normalized OCR geometry uses an upright image with a top-left origin.
public enum OCRGeometry {
    public static func confidence(_ value: Double) -> Double? {
        guard value.isFinite else { return nil }
        return min(1, max(0, value))
    }

    /// Vision rectangles use a bottom-left origin. Reject non-finite, reversed, or
    /// non-intersecting rectangles; clip the rest to the image before conversion.
    public static func visionBBox(minX: Double, minY: Double,
                                  maxX: Double, maxY: Double) -> [Double]? {
        guard [minX, minY, maxX, maxY].allSatisfy(\.isFinite),
              maxX > minX, maxY > minY else { return nil }
        let left = min(1, max(0, minX))
        let right = min(1, max(0, maxX))
        let bottom = min(1, max(0, minY))
        let top = min(1, max(0, maxY))
        guard right > left, top > bottom else { return nil }
        return [left, 1 - top, right - left, top - bottom]
    }

    /// Existing OCR checkpoints may have been written by an earlier build.
    /// Normalize their top-left rectangles at archive time without rerunning OCR.
    public static func storedBBox(_ box: [Double]) -> [Double]? {
        guard box.count == 4, box.allSatisfy(\.isFinite),
              box[2] > 0, box[3] > 0 else { return nil }
        let right = box[0] + box[2]
        let bottom = box[1] + box[3]
        guard right.isFinite, bottom.isFinite else { return nil }
        let left = min(1, max(0, box[0]))
        let top = min(1, max(0, box[1]))
        let clippedRight = min(1, max(0, right))
        let clippedBottom = min(1, max(0, bottom))
        guard clippedRight > left, clippedBottom > top else { return nil }
        return [left, top, clippedRight - left, clippedBottom - top]
    }
}
