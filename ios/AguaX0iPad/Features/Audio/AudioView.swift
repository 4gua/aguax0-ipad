import SwiftUI

struct AudioView: View {
    @StateObject private var podcastService = PodcastService()
    @State private var appeared = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {

                // ── NOW PLAYING
                NowPlayingFullCard()
                    .offset(y: appeared ? 0 : 20)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

                // ── APPLE MUSIC
                AppleMusicPlaceholder()
                    .offset(y: appeared ? 0 : 20)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.2), value: appeared)

                // ── PODCASTS
                QueueView(podcastService: podcastService)
                    .offset(y: appeared ? 0 : 20)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 100)
        }
        .onAppear {
            appeared = true
            podcastService.fetchAll()
        }
        .onDisappear { appeared = false }
    }
}

struct AppleMusicPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("APPLE MUSIC")
                .font(.system(size: 9, weight: .semibold))
                .tracking(4)
                .foregroundColor(Color(hex: "8B6F3F"))

            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.98, green: 0.26, blue: 0.41),
                                    Color(red: 0.7, green: 0.1, blue: 0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                    Image(systemName: "music.note")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Apple Music")
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .foregroundColor(.white)
                    Text("MusicKit integration coming soon")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8B6F3F"))
                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 9))
                        Text("Requires MusicKit entitlement")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(Color(hex: "8B6F3F").opacity(0.6))
                }

                Spacer()
            }
            .padding(20)
            .background(Color(hex: "C9A961").opacity(0.04))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(16)
        }
    }
}
