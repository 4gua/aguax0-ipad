import SwiftUI

struct InfoCardsView: View {
    var body: some View {
        HStack(spacing: 10) {
            WeatherCard()
            LastMemoCard()
            StudyStreakCard()
        }
    }
}

// ── WEATHER CARD ─────────────────────────────────────────────
struct WeatherCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("OUTSIDE")
                    .font(.system(size: 8, weight: .semibold))
                    .tracking(3)
                    .foregroundColor(Color(hex: "8B6F3F"))
                Spacer()
                Image(systemName: "sun.max")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "C9A961"))
            }
            Spacer()
            Text("68°")
                .font(.system(size: 36, weight: .thin, design: .serif))
                .foregroundColor(.white)
            Text("Clear · Santa Monica")
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

// ── LAST MEMO CARD ───────────────────────────────────────────
struct LastMemoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(systemName: "mic")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "C9A961"))
                Text("LAST MEMO")
                    .font(.system(size: 8, weight: .semibold))
                    .tracking(3)
                    .foregroundColor(Color(hex: "8B6F3F"))
            }
            Spacer()
            Text("\"Idea for Q3 launch — onboarding friction first…\"")
                .font(.system(size: 12, weight: .light, design: .serif))
                .foregroundColor(.white)
                .italic()
                .lineLimit(3)
            Spacer()
            Text("2:14 PM · Coast Hwy")
                .font(.system(size: 8))
                .foregroundColor(Color(hex: "8B6F3F"))
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}

// ── STUDY STREAK CARD ────────────────────────────────────────
struct StudyStreakCard: View {
    let bars: [CGFloat] = [0.4, 0.7, 0.55, 0.85, 0.6, 0.9, 0.45]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(systemName: "flame")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "C9A961"))
                Text("STREAK")
                    .font(.system(size: 8, weight: .semibold))
                    .tracking(3)
                    .foregroundColor(Color(hex: "8B6F3F"))
            }
            Spacer()
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text("14")
                    .font(.system(size: 32, weight: .thin, design: .serif))
                    .foregroundColor(Color(hex: "C9A961"))
                Text("days")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }
            Spacer()
            // Mini bar chart
            HStack(alignment: .bottom, spacing: 3) {
                ForEach(0..<bars.count, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(i >= 5
                              ? Color(hex: "C9A961")
                              : Color(hex: "8B6F3F").opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 20 * bars[i])
                }
            }
            .frame(height: 20)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}
//  InfoCardsView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

