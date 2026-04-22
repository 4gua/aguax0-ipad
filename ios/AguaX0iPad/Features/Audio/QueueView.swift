import SwiftUI

struct QueueItem: Identifiable {
    let id = UUID()
    let show: String
    let episode: String
    let duration: String
    let isPlaying: Bool
}

struct QueueView: View {
    let items: [QueueItem] = [
        QueueItem(show: "The Huberman Lab", episode: "Ep. 184 · Focus & Flow States", duration: "1h 16m", isPlaying: true),
        QueueItem(show: "Lex Fridman Podcast", episode: "Ep. 421 · AI & The Future", duration: "2h 34m", isPlaying: false),
        QueueItem(show: "Tim Ferriss Show", episode: "Ep. 712 · Morning Routines", duration: "58m", isPlaying: false),
        QueueItem(show: "The Daily", episode: "Apr 22 · Today's Headlines", duration: "24m", isPlaying: false),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("UP NEXT")
                .font(.system(size: 9, weight: .semibold))
                .tracking(4)
                .foregroundColor(Color(hex: "8B6F3F"))

            VStack(spacing: 1) {
                ForEach(items) { item in
                    QueueRow(item: item)
                    if item.id != items.last?.id {
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

struct QueueRow: View {
    let item: QueueItem

    var body: some View {
        HStack(spacing: 12) {
            // Artwork
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        item.isPlaying
                            ? LinearGradient(colors: [Color(hex: "C9A961"), Color(hex: "8B6F3F")], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color(hex: "8B6F3F").opacity(0.3), Color(hex: "8B6F3F").opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 40, height: 40)
                Image(systemName: item.isPlaying ? "waveform" : "headphones")
                    .font(.system(size: 14))
                    .foregroundColor(item.isPlaying ? Color(hex: "0D0A07") : Color(hex: "8B6F3F"))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(item.show)
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundColor(item.isPlaying ? Color(hex: "C9A961") : .white)
                    .lineLimit(1)
                Text(item.episode)
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "8B6F3F"))
                    .lineLimit(1)
            }

            Spacer()

            Text(item.duration)
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "8B6F3F"))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}
