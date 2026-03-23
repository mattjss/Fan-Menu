import SwiftUI

/// Radial fan menu: the trigger stays fixed; items arc outward with staggered spring motion.
struct FanMenuView: View {
    let items: [FanMenuItem]

    @State private var isExpanded = false

    private let fanRadius: CGFloat = 112
    /// Total sweep of the arc (radians), centered above the trigger.
    private let fanSpread: CGFloat = .pi * 0.62
    private let itemSize: CGFloat = 48
    private let stagger: Double = 0.038

    var body: some View {
        GeometryReader { proxy in
            let anchor = CGPoint(
                x: proxy.size.width / 2,
                y: proxy.size.height - proxy.safeAreaInsets.bottom - 56
            )

            ZStack(alignment: .topLeading) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    fanItem(item, index: index, anchor: anchor)
                }

                triggerButton(anchor: anchor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    @ViewBuilder
    private func fanItem(_ item: FanMenuItem, index: Int, anchor: CGPoint) -> some View {
        let offset = fanOffset(for: index, expanded: isExpanded)
        let rotation = fanRotation(for: index, expanded: isExpanded)

        Button {
            isExpanded = false
        } label: {
            Image(systemName: item.icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: itemSize, height: itemSize)
                .background(.ultraThinMaterial, in: Circle())
                .overlay {
                    Circle()
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
        .rotationEffect(.degrees(rotation))
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
        .accessibilityLabel(item.label)
    }

    private func triggerButton(anchor: CGPoint) -> some View {
        Button {
            isExpanded.toggle()
        } label: {
            Image(systemName: isExpanded ? "xmark" : "line.3.horizontal")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: 56, height: 56)
                .background(.thinMaterial, in: Circle())
                .overlay {
                    Circle()
                        .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
        .rotationEffect(.degrees(isExpanded ? 90 : 0))
        .animation(.spring(response: 0.42, dampingFraction: 0.82), value: isExpanded)
        .position(x: anchor.x, y: anchor.y)
        .accessibilityLabel(isExpanded ? "Close menu" : "Open menu")
    }

    /// Polar offset from the anchor; angles are measured from +x, fan opens toward −y (up on screen).
    private func fanOffset(for index: Int, expanded: Bool) -> CGSize {
        let r = expanded ? fanRadius : 0
        let angle = angleRadians(for: index)
        return CGSize(
            width: CGFloat(cos(angle)) * r,
            height: CGFloat(-sin(angle)) * r
        )
    }

    private func fanRotation(for index: Int, expanded: Bool) -> Double {
        guard expanded else { return 0 }
        let angle = angleRadians(for: index)
        // Keep icons upright but add a subtle radial tilt for depth.
        let radialTilt = (angle - .pi / 2) * 0.35
        return Double(radialTilt * 180 / .pi)
    }

    private func angleRadians(for index: Int) -> CGFloat {
        let count = max(items.count, 1)
        let t = count > 1 ? CGFloat(index) / CGFloat(count - 1) : 0.5
        let start = .pi / 2 - fanSpread / 2
        return start + t * fanSpread
    }
}

#Preview {
    FanMenuView(
        items: [
            FanMenuItem(icon: "star.fill", label: "Star"),
            FanMenuItem(icon: "moon.fill", label: "Moon"),
            FanMenuItem(icon: "cloud.fill", label: "Cloud"),
        ]
    )
}
