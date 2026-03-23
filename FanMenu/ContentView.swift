import SwiftUI

struct ContentView: View {
    private let menuItems: [FanMenuItem] = [
        FanMenuItem(icon: "house.fill", label: "Home"),
        FanMenuItem(icon: "heart.fill", label: "Favorites"),
        FanMenuItem(icon: "magnifyingglass", label: "Search"),
        FanMenuItem(icon: "person.fill", label: "Profile"),
        FanMenuItem(icon: "gearshape.fill", label: "Settings"),
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.secondarySystemBackground),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            FanMenuView(items: menuItems)
        }
    }
}

#Preview {
    ContentView()
}
