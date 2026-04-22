import SwiftUI

enum ParkedTab {
    case home
    case journey
    case audio
    case journal
    case study
}

struct TabBarView: View {
    @Binding var selectedTab: ParkedTab

    var body: some View {
        HStack(spacing: 4) {
            TabBarButton(icon: "gauge", label: "Home",    tab: .home,    selected: $selectedTab)
            TabBarButton(icon: "location", label: "Journey", tab: .journey, selected: $selectedTab)
            TabBarButton(icon: "music.note", label: "Audio",   tab: .audio,   selected: $selectedTab)
            TabBarButton(icon: "pencil", label: "Journal", tab: .journal, selected: $selectedTab)
            TabBarButton(icon: "book", label: "Study",   tab: .study,   selected: $selectedTab)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color(hex: "0D0A07"))
                .overlay(
                    Capsule()
                        .stroke(Color(hex: "8B6F3F").opacity(0.4), lineWidth: 1)
                )
        )
    }
}

struct TabBarButton: View {
    var icon: String
    var label: String
    var tab: ParkedTab
    @Binding var selected: ParkedTab

    private var isSelected: Bool { selected == tab }

    var body: some View {
        Button(action: { selected = tab }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                Text(label.uppercased())
                    .font(.system(size: 7, weight: .semibold))
                    .tracking(2)
            }
            .foregroundColor(isSelected ? Color(hex: "C9A961") : Color(hex: "8B6F3F"))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                isSelected
                    ? Color(hex: "C9A961").opacity(0.12)
                    : Color.clear
            )
            .clipShape(Capsule())
        }
    }
}
//  TabBarView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

