import SwiftUI

struct StatusBarView: View {
    var mode: VehicleMode
    @State private var now = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var timeString: String {
        let h = Calendar.current.component(.hour, from: now)
        let m = Calendar.current.component(.minute, from: now)
        let hh = ((h + 11) % 12) + 1
        let mm = String(format: "%02d", m)
        let ampm = h >= 12 ? "PM" : "AM"
        return "\(hh):\(mm) \(ampm)"
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {

                // LEFT: Wordmark + mode
                HStack(spacing: 8) {
                    HStack(spacing: 0) {
                        Text("Agua")
                            .font(.system(size: 17, weight: .medium, design: .serif))
                            .italic()
                            .foregroundColor(.white)
                        Text("X0")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(2)
                            .foregroundColor(Color(hex: "C9A961"))
                            .baselineOffset(-2)
                    }

                    Rectangle()
                        .fill(Color(hex: "8B6F3F"))
                        .frame(width: 1, height: 12)

                    Text(mode == .driving ? "UNDERWAY" : "SANCTUARY")
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(4)
                        .foregroundColor(Color(hex: "8B6F3F"))
                }

                Spacer()

                // RIGHT: Location + time + icons
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "C9A961"))
                        Text("Santa Monica")
                            .font(.system(size: 11))
                            .foregroundColor(.white)
                    }

                    Rectangle()
                        .fill(Color(hex: "8B6F3F"))
                        .frame(width: 1, height: 12)

                    Text(timeString)
                        .font(.system(size: 11))
                        .tracking(2)
                        .foregroundColor(.white)
                        .onReceive(timer) { _ in now = Date() }

                    HStack(spacing: 4) {
                        Image(systemName: "wifi")
                            .font(.system(size: 10))
                        Image(systemName: "battery.100")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 10)

            // Divider
            LinearGradient(
                colors: [
                    Color.clear,
                    Color(hex: "8B6F3F").opacity(0.5),
                    Color.clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "0D0A07").opacity(0.97),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
//  StatusBarView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

