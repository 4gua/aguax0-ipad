import SwiftUI

struct QueueView: View {
    @ObservedObject var podcastService: PodcastService

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("LATEST EPISODES")
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(4)
                    .foregroundColor(Color(hex: "8B6F3F"))
                Spacer()
                if podcastService.isLoading {
                    ProgressView()
                        .tint(Color(hex: "C9A961"))
                        .scaleEffect(0.7)
                }
            }

            if podcastService.episodes.isEmpty && !podcastService.isLoading {
                Text("No episodes loaded")
                    .font(.system(size: 12, design: .serif))
                    .foregroundColor(Color(hex: "8B6F3F"))
                    .italic()
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 1) {
                    ForEach(podcastService.episodes) { episode in
                        QueueRow(episode: episode)
                        if episode.id != podcastService.episodes.last?.id {
                            Divider()
                                .background(Color(hex: "8B6F3F").opacity(0.2))
                                .padding(.leading, 56)
                        }
                    }
                }
                .background(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(14)
            }
        }
    }
}

struct QueueRow: View {
    let episode: PodcastEpisode

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "8B6F3F").opacity(0.3), Color(hex: "8B6F3F").opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                Image(systemName: "headphones")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8B6F3F"))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(episode.show)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(hex: "C9A961"))
                    .lineLimit(1)
                Text(episode.title)
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(episode.pubDate)
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "8B6F3F"))
            }

            Spacer()

            Text(episode.duration)
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "8B6F3F"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}
