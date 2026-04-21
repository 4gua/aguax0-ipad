import SwiftUI

@main
struct AguaX0iPadApp: App {
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(locationManager)
                .task {
                    locationManager.start()
                }
        }
    }
}
