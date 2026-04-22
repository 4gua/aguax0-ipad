import SwiftUI

struct SavedPlacesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SAVED PLACES")
                .font(.system(size: 9, weight: .semibold))
                .tracking(4)
                .foregroundColor(Color(hex: "8B6F3F"))

            HStack(spacing: 10) {
                SavedPlaceButton(
                    icon: "house.fill",
                    label: "Home",
                    detail: "6 min · 1.2 mi"
                )
                SavedPlaceButton(
                    icon: "briefcase.fill",
                    label: "Work",
                    detail: "22 min · 8.4 mi"
                )
            }
        }
    }
}

struct SavedPlaceButton: View {
    var icon: String
    var label: String
    var detail: String

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "C9A961").opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "C9A961"))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.system(size: 17, weight: .medium, design: .serif))
                        .foregroundColor(.white)
                    Text(detail)
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "8B6F3F"))
                }

                Spacer()

                Image(systemName: "arrow.turn.up.right")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "C9A961"))
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "8B6F3F").opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(14)
        }
    }
}
//  SavedPlacesView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

