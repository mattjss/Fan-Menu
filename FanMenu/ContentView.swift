import SwiftUI

struct ContentView: View {
    /// Order and labels match Figma: Settings → Dashboard, with per-chip tilts in `FanMenuView`.
    private let menuItems: [FanMenuItem] = [
        FanMenuItem(icon: "switch.2", label: "Settings"),
        FanMenuItem(icon: "calendar", label: "Calendar"),
        FanMenuItem(icon: "curlybraces.square", label: "Documents"),
        FanMenuItem(icon: "flask.fill", label: "Experiments"),
        FanMenuItem(icon: "square.grid.3x3.fill", label: "Dashboard"),
    ]

    var body: some View {
        ZStack {
            FigmaFanTokens.canvas
                .ignoresSafeArea()

            FanMenuView(items: menuItems)
        }
    }
}

#Preview {
    ContentView()
}
