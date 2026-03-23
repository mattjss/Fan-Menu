import SwiftUI

/// Fan menu matching Figma: compact frame (2672:4164) animates into full frame (2672:4035).
struct FanMenuView: View {
    let items: [FanMenuItem]

    @State private var isExpanded = false
    /// 0 = compact styling (4164), 1 = full styling (4035). Driven with the open/close animation.
    @State private var layoutProgress: CGFloat = 0

    private let stagger: Double = 0.038

    /// Arc sweep in degrees: fan opens upward with items toward the left (Figma layout).
    private let angleStartDegrees: CGFloat = 78
    private let angleEndDegrees: CGFloat = 122

    var body: some View {
        GeometryReader { proxy in
            let anchor = CGPoint(
                x: proxy.size.width / 2,
                y: proxy.size.height - proxy.safeAreaInsets.bottom - 40
            )

            ZStack(alignment: .topLeading) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    fanItem(item, index: index, anchor: anchor)
                }

                triggerButton(anchor: anchor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .onChange(of: isExpanded) { _, expanded in
            withAnimation(.spring(response: 0.52, dampingFraction: 0.82)) {
                layoutProgress = expanded ? 1 : 0
            }
        }
    }

    @ViewBuilder
    private func fanItem(_ item: FanMenuItem, index: Int, anchor: CGPoint) -> some View {
        let offset = fanOffset(for: index)
        let tilt = FigmaFanTokens.tiltDegrees(itemIndex: index, itemCount: items.count)

        let corner = FigmaFanTokens.lerp(
            FigmaFanTokens.compactPillCorner,
            FigmaFanTokens.fullPillCorner,
            layoutProgress
        )
        let fontSize = FigmaFanTokens.lerp(
            FigmaFanTokens.compactFontSize,
            FigmaFanTokens.fullFontSize,
            layoutProgress
        )
        let iconSize = FigmaFanTokens.lerp(
            FigmaFanTokens.compactIconSize,
            FigmaFanTokens.fullIconSize,
            layoutProgress
        )
        let padH = FigmaFanTokens.lerp(
            FigmaFanTokens.compactPaddingH,
            FigmaFanTokens.fullPaddingH,
            layoutProgress
        )
        let padV = FigmaFanTokens.lerp(
            FigmaFanTokens.compactPaddingV,
            FigmaFanTokens.fullPaddingV,
            layoutProgress
        )
        let gap = FigmaFanTokens.lerp(
            FigmaFanTokens.compactItemGap,
            FigmaFanTokens.fullItemGap,
            layoutProgress
        )
        let shadowR = FigmaFanTokens.lerp(
            FigmaFanTokens.compactShadowRadius,
            FigmaFanTokens.fullShadowRadius,
            layoutProgress
        )
        let shadowY = FigmaFanTokens.lerp(
            FigmaFanTokens.compactShadowY,
            FigmaFanTokens.fullShadowY,
            layoutProgress
        )
        let tracking = FigmaFanTokens.lerp(
            FigmaFanTokens.compactTracking,
            FigmaFanTokens.fullTracking,
            layoutProgress
        )

        Button {
            isExpanded = false
        } label: {
            HStack(spacing: gap) {
                Image(systemName: item.icon)
                    .font(.system(size: iconSize, weight: .medium))
                    .foregroundStyle(FigmaFanTokens.label)
                    .frame(width: iconSize, height: iconSize)

                Text(item.label)
                    .font(.system(size: fontSize, weight: .medium))
                    .foregroundStyle(FigmaFanTokens.label)
                    .tracking(tracking)
            }
            .padding(.horizontal, padH)
            .padding(.vertical, padV)
            .background(FigmaFanTokens.surface, in: RoundedRectangle(cornerRadius: corner, style: .continuous))
            .shadow(color: FigmaFanTokens.itemShadowColor, radius: shadowR, x: 0, y: shadowY)
        }
        .buttonStyle(.plain)
        .rotationEffect(.degrees(tilt))
        .opacity(isExpanded ? 1 : 0)
        .scaleEffect(isExpanded ? 1 : 0.35)
        .position(
            x: anchor.x + offset.width,
            y: anchor.y + offset.height
        )
        .animation(
            .spring(response: 0.48, dampingFraction: 0.78)
                .delay(Double(index) * stagger),
            value: isExpanded
        )
        .animation(.spring(response: 0.52, dampingFraction: 0.82), value: layoutProgress)
        .allowsHitTesting(isExpanded)
        .accessibilityLabel(item.label)
    }

    private func triggerButton(anchor: CGPoint) -> some View {
        Button {
            isExpanded.toggle()
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: FigmaFanTokens.menuIconSize, weight: .medium))
                .foregroundStyle(FigmaFanTokens.label)
                .frame(width: FigmaFanTokens.menuSize, height: FigmaFanTokens.menuSize)
                .background(FigmaFanTokens.surface, in: RoundedRectangle(cornerRadius: FigmaFanTokens.menuCornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: FigmaFanTokens.menuCornerRadius, style: .continuous)
                        .strokeBorder(FigmaFanTokens.menuStroke, lineWidth: 1)
                }
                .shadow(color: FigmaFanTokens.itemShadowColor.opacity(0.45), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .rotationEffect(.degrees(isExpanded ? -45 : 0))
        .animation(.spring(response: 0.45, dampingFraction: 0.82), value: isExpanded)
        .position(x: anchor.x, y: anchor.y)
        .accessibilityLabel(isExpanded ? "Close menu" : "Open menu")
    }

    /// Polar offset: radius grows per index (fan trail) and with layout progress (4164 → 4035).
    private func fanOffset(for index: Int) -> CGSize {
        let base = FigmaFanTokens.lerp(36, 78, layoutProgress)
        let step = FigmaFanTokens.lerp(10, 24, layoutProgress)
        let r = isExpanded ? (base + CGFloat(index) * step) : 0
        let angle = angleRadians(for: index)
        return CGSize(
            width: CGFloat(cos(angle)) * r,
            height: CGFloat(-sin(angle)) * r
        )
    }

    private func angleRadians(for index: Int) -> CGFloat {
        let count = max(items.count, 1)
        let t = count > 1 ? CGFloat(index) / CGFloat(count - 1) : 0.5
        let start = angleStartDegrees * .pi / 180
        let end = angleEndDegrees * .pi / 180
        return start + (end - start) * t
    }
}

#Preview("Figma items") {
    ZStack {
        FigmaFanTokens.canvas.ignoresSafeArea()
        FanMenuView(
            items: [
                FanMenuItem(icon: "switch.2", label: "Settings"),
                FanMenuItem(icon: "calendar", label: "Calendar"),
                FanMenuItem(icon: "curlybraces.square", label: "Documents"),
                FanMenuItem(icon: "flask.fill", label: "Experiments"),
                FanMenuItem(icon: "square.grid.3x3.fill", label: "Dashboard"),
            ]
        )
    }
}
