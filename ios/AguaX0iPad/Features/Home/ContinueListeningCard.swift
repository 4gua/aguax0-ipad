import SwiftUI

struct ContinueListeningCard: View {
    @State private var playing = false

    var body: some View {
        HStack(spacing: 12) {

            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "C9A961"), Color(hex: "8B6F3F")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                Image(systemName: "radio")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "0D0A07"))
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text("CONTINUE LISTENING")
                    .font(.system(size: 8, weight: .semibold))
                    .tracking(3)
                    .foregroundColor(Color(hex: "C9A961"))
                Text("The Huberman Lab · Ep 184")
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(1)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color(hex: "8B6F3F").opacity(0.4))
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color(hex: "C9A961"))
                            .frame(width: geo.size.width * 0.38)
                    }
                }
                .frame(height: 2)

                Text("38 min left")
                    .font(.system(size: 9))
                    .foregroundColor(Color(hex: "8B6F3F"))
            }

            Spacer()

            // Play button
            Button(action: { playing.toggle() }) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "C9A961"))
                        .frame(width: 38, height: 38)
                        .shadow(color: Color(hex: "C9A961").opacity(0.4), radius: 8)
                    Image(systemName: playing ? "pause.fill" : "play.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "0D0A07"))
                        .offset(x: playing ? 0 : 1)
                }
            }
        }
        .padding(14)
        .background(Color.black.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}
//  ContinueListeningCard.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

