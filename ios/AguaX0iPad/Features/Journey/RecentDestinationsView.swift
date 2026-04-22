import SwiftUI

struct RecentDestination: Identifiable {
    let id = UUID()
    let name: String
    let detail: String
    let icon: String
}

struct RecentDestinationsView: View {
    let recents: [RecentDestination] = [
        RecentDestination(name: "Trader Joe's", detail: "Wilshire Blvd · 8 min", icon: "cart.fill"),
        RecentDestination(name: "Downtown", detail: "Grand Ave · 24 min", icon: "building.2.fill"),
        RecentDestination(name: "Gas Station", detail: "Olympic Blvd · 4 min", icon: "fuelpump.fill"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("RECENT")
                .font(.system(size: 9, weight: .semibold))
                .tracking(4)
                .foregroundColor(Color(hex: "8B6F3F"))

            VStack(spacing: 1) {
                ForEach(recents) { place in
                    RecentRow(destination: place)
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

struct RecentRow: View {
    var destination: RecentDestination

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                Image(systemName: destination.icon)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "8B6F3F"))
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 2) {
                    Text(destination.name)
                        .font(.system(size: 15, weight: .medium, design: .serif))
                        .foregroundColor(.white)
                    Text(destination.detail)
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "8B6F3F"))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "8B6F3F").opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }

        if destination.id != destination.id {
            Divider()
                .background(Color(hex: "8B6F3F").opacity(0.2))
        }
    }
}
//  RecentDestinationsView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

