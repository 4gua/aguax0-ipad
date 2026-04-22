import SwiftUI

struct NowPlayingFullCard: View {
    @State private var playing = true
    @State private var progress: Double = 0.38

    var body: some View {
        VStack(spacing: 16) {

            // ── HEADER
            Text("NOW PLAYING")
                .font(.system(size: 9, weight: .semibold))
                .tracking(4)
                .foregroundColor(Color(hex: "C9A961"))
                .frame(maxWidth: .infinity, alignment: .leading)

            // ── ARTWORK + INFO
            HStack(spacing: 16) {
                // Artwork
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "C9A961"), Color(hex: "8B6F3F")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    Image(systemName: "waveform")
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: "0D0A07").opacity(0.6))
                }

                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text("The Huberman Lab")
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .foregroundColor(.white)
                    Text("Ep. 184 · Focus & Flow States")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8B6F3F"))
                    Text("Andrew Huberman")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "8B6F3F").opacity(0.7))
                }

                Spacer()
            }

            // ── PROGRESS BAR
            VStack(spacing: 6) {
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
                            .frame(width: geo.size.width * progress)
                    }
                }
                .frame(height: 3)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // Will be wired to AVPlayer later
                        }
                )

                HStack {
                    Text("38:24")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "8B6F3F"))
                    Spacer()
                    Text("-38:12")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "8B6F3F"))
                }
            }

            // ── CONTROLS
            HStack(spacing: 32) {
                // Skip back 15s
                Button(action: {}) {
                    VStack(spacing: 2) {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 22))
                        Text("15")
                            .font(.system(size: 8))
                    }
                    .foregroundColor(Color(hex: "C9A961").opacity(0.8))
                }

                // Previous
                Button(action: {}) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white.opacity(0.7))
                }

                // Play/Pause
                Button(action: { playing.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "C9A961"))
                            .frame(width: 64, height: 64)
                            .shadow(color: Color(hex: "C9A961").opacity(0.4), radius: 16)
                        Image(systemName: playing ? "pause.fill" : "play.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "0D0A07"))
                    }
                }

                // Next
                Button(action: {}) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white.opacity(0.7))
                }

                // Skip forward 30s
                Button(action: {}) {
                    VStack(spacing: 2) {
                        Image(systemName: "goforward.30")
                            .font(.system(size: 22))
                        Text("30")
                            .font(.system(size: 8))
                    }
                    .foregroundColor(Color(hex: "C9A961").opacity(0.8))
                }
            }

            // ── PLAYBACK SPEED
            HStack(spacing: 0) {
                ForEach(["0.75x", "1x", "1.25x", "1.5x", "2x"], id: \.self) { speed in
                    Button(action: {}) {
                        Text(speed)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(speed == "1x" ? Color(hex: "0D0A07") : Color(hex: "C9A961"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(speed == "1x" ? Color(hex: "C9A961") : Color.clear)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(4)
            .background(Color.black.opacity(0.3))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
            )
        }
        .padding(20)
        .background(Color(hex: "C9A961").opacity(0.06))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "8B6F3F").opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}//
//  NowPlayingFullCard.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/22/26.
//

