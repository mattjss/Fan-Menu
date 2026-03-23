import SwiftUI

/// Colors and metrics from Figma (P26-Projects): nodes 2672:4164 (compact) and 2672:4035 (full).
enum FigmaFanTokens {
    static let canvas = Color(red: 0, green: 0, blue: 0)
    static let surface = Color.white
    static let label = Color(red: 79 / 255, green: 79 / 255, blue: 79 / 255)
    static let menuStroke = Color(red: 223 / 255, green: 223 / 255, blue: 223 / 255)

    /// Item drop shadow — `0px 4px 4px rgba(146,146,146,0.35)` (full state).
    static let itemShadowColor = Color(red: 146 / 255, green: 146 / 255, blue: 146 / 255)
        .opacity(0.35)

    // MARK: - Full (4035)

    static let fullPillCorner: CGFloat = 32
    static let fullFontSize: CGFloat = 12
    static let fullIconSize: CGFloat = 16
    static let fullPaddingH: CGFloat = 12
    static let fullPaddingV: CGFloat = 8
    static let fullItemGap: CGFloat = 6
    static let fullShadowRadius: CGFloat = 4
    static let fullShadowY: CGFloat = 4
    static let fullTracking: CGFloat = -0.096

    static let menuSize: CGFloat = 42
    static let menuIconSize: CGFloat = 20
    static let menuCornerRadius: CGFloat = 21

    // MARK: - Compact (4164), scaled to match export ratios vs. full

    static let compactPillCorner: CGFloat = 8
    static let compactFontSize: CGFloat = 10
    static let compactIconSize: CGFloat = 12
    static let compactPaddingH: CGFloat = 6
    static let compactPaddingV: CGFloat = 4
    static let compactItemGap: CGFloat = 3
    static let compactShadowRadius: CGFloat = 1
    static let compactShadowY: CGFloat = 1
    static let compactTracking: CGFloat = -0.08

    /// Per-chip rotation in ° — Settings … Dashboard (Figma `-rotate-*`).
    static let itemTiltsDegrees: [Double] = [0, -5, -10, -20, -30]

    static func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }

    static func tiltDegrees(itemIndex: Int, itemCount: Int) -> Double {
        guard itemCount == itemTiltsDegrees.count, itemIndex < itemTiltsDegrees.count else {
            let n = max(itemCount - 1, 1)
            let t = Double(itemIndex) / Double(n)
            return t * -30
        }
        return itemTiltsDegrees[itemIndex]
    }
}
