import Foundation
import SwiftUI

class DriveStateManager: ObservableObject {
    @Published var mode: VehicleMode = .parked

    private var driveTimer: Timer?
    private var parkTimer:  Timer?

    private let driveThreshold:   Double = 10
    private let parkThreshold:    Double = 2
    private let driveHoldSeconds: Double = 5
    private let parkHoldSeconds:  Double = 30

    func update(speed: Double) {
        if mode == .parked && speed > driveThreshold {
            if driveTimer == nil {
                driveTimer = Timer.scheduledTimer(
                    withTimeInterval: driveHoldSeconds,
                    repeats: false
                ) { [weak self] (_: Timer) in
                    self?.transition(to: .driving)
                }
            }
        } else if speed <= driveThreshold {
            driveTimer?.invalidate()
            driveTimer = nil
        }

        if mode == .driving && speed < parkThreshold {
            if parkTimer == nil {
                parkTimer = Timer.scheduledTimer(
                    withTimeInterval: parkHoldSeconds,
                    repeats: false
                ) { [weak self] (_: Timer) in
                    self?.transition(to: .parked)
                }
            }
        } else if speed >= parkThreshold {
            parkTimer?.invalidate()
            parkTimer = nil
        }
    }

    private func transition(to newMode: VehicleMode) {
        driveTimer?.invalidate()
        parkTimer?.invalidate()
        driveTimer = nil
        parkTimer = nil
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.mode = newMode
            }
        }
    }
}
