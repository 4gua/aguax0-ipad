import SwiftUI

struct ETACard: View {
    var eta: String = "6:42 PM"
    var remaining: String = "18 min"

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("ETA")
                    .font(.system(size: 8, weight: .semibold))
                    .tracking(4)
                    .foregroundColor(Color(hex: "8B6F3F"))
                Text(eta)
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundColor(.white)
            }

            Spacer()

            Rectangle()
                .fill(Color(hex: "8B6F3F").opacity(0.5))
                .frame(width: 1, height: 30)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("REMAINING")
                    .font(.system(size: 8, weight: .semibold))
                    .tracking(4)
                    .foregroundColor(Color(hex: "8B6F3F"))
                Text(remaining)
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}
//  ETACard.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

