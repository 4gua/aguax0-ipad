import SwiftUI

struct VehicleHeroView: View {
    var mode: VehicleMode = .parked

    var body: some View {
        HStack(spacing: 0) {

            // LEFT — 3D car viewer
            ZStack {
                // Grid floor
                LinearGradient(
                    colors: [Color.clear, Color(hex: "C9A961").opacity(0.06)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity, alignment: .bottom)

                // 3D model viewer
                EmbeddedModelViewer(mode: mode)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity)

            // DIVIDER
            Rectangle()
                .fill(Color(hex: "8B6F3F").opacity(0.35))
                .frame(width: 1)
                .padding(.vertical, 12)

            // RIGHT — Vehicle stats
            VStack(alignment: .leading, spacing: 12) {
                StatRow(label: "Estimated Range", value: "287", unit: "miles")
                FuelRow()
                StatRow(label: "Odometer", value: "42,156", unit: "mi")
                StatRow(label: "Last Trip", value: "24.6 mi · 48 min", unit: "")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(width: 220)
        }
        .frame(height: 180)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "C9A961").opacity(0.08),
                    Color.black.opacity(0.5)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "C9A961").opacity(0.35), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

struct StatRow: View {
    var label: String
    var value: String
    var unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.system(size: 8, weight: .semibold))
                .tracking(3)
                .foregroundColor(Color(hex: "8B6F3F"))
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(
                        size: unit.isEmpty ? 14 : 22,
                        weight: .light,
                        design: .serif))
                    .foregroundColor(.white)
                    .italic(unit.isEmpty)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "8B6F3F"))
                }
            }
        }
    }
}

struct FuelRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("FUEL LEVEL")
                .font(.system(size: 8, weight: .semibold))
                .tracking(3)
                .foregroundColor(Color(hex: "8B6F3F"))
            HStack(spacing: 8) {
                Image(systemName: "fuelpump")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "C9A961"))
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(hex: "8B6F3F").opacity(0.3))
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "C9A961"), Color(hex: "E8CF95")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * 0.62)
                    }
                }
                .frame(height: 6)
                Text("62%")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }
}
