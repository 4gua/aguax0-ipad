import SwiftUI

struct NowPlayingCard: View {
    @State private var playing = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NOW PLAYING")
                .font(.system(size: 8, weight: .semibold))
                .tracking(4)
                .foregroundColor(Color(hex: "C9A961"))

            Text("The Huberman Lab")
                .font(.system(size: 14, weight: .medium, design: .serif))
                .foregroundColor(.white)
                .lineLimit(1)

            Text("Ep. 184 · Focus & Flow")
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "8B6F3F"))
                .lineLimit(1)

            HStack(spacing: 20) {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "backward.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
                Button(action: { playing.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "C9A961"))
                            .frame(width: 40, height: 40)
                        Image(systemName: playing ? "pause.fill" : "play.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "0D0A07"))
                    }
                }
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
            }
        }
        .padding(12)
        .background(Color(hex: "C9A961").opacity(0.06))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "8B6F3F").opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}
//  NowPlayingCard.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

