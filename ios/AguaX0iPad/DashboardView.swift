import SwiftUI

enum VehicleMode {
    case parked
    case driving
}

struct DashboardView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var driveState = DriveStateManager()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if driveState.mode == .driving {
                DrivingView(speed: locationManager.speedMPH)
                    .transition(.opacity)
            } else {
                ParkedView()
                    .transition(.opacity)
            }
        }
        .onChange(of: locationManager.speedMPH) { _, speed in
            driveState.update(speed: speed)
        }
    }
}
