import SwiftUI

struct TurnStripView: View {
    var streetName: String = "Ocean Avenue"
    var distance: String = "0.4"
    var direction: String = "Right Turn"

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "arrow.turn.up.right")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color(hex: "C9A961"))

            VStack(alignment: .leading, spacing: 2) {
                Text("NEXT · \(direction.uppercased())")
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(4)
                    .foregroundColor(Color(hex: "8B6F3F"))
                Text(streetName)
                    .font(.system(size: 20, weight: .medium, design: .serif))
                    .foregroundColor(.white)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(distance)
                    .font(.system(size: 28, weight: .light, design: .serif))
                    .foregroundColor(Color(hex: "C9A961"))
                Text("MI")
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(4)
                    .foregroundColor(Color(hex: "8B6F3F"))
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "C9A961").opacity(0.1),
                    Color.black.opacity(0.3)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex: "C9A961").opacity(0.35)),
            alignment: .bottom
        )
    }
}
//  TurnStripView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

