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
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 1.02)),
                            removal: .opacity.combined(with: .scale(scale: 0.98))
                        )
                    )
            } else {
                ParkedView()
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 1.02)),
                            removal: .opacity.combined(with: .scale(scale: 0.98))
                        )
                    )
            }
        }
        .animation(.easeInOut(duration: 0.8), value: driveState.mode)
        .onChange(of: locationManager.speedMPH) { _, speed in
            driveState.update(speed: speed)
        }
    }
}
