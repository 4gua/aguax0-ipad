import SwiftUI
import MapKit

struct PlaceSuggestionsView: View {
    var suggestions: [MKLocalSearchCompletion]
    var onSelect: (MKLocalSearchCompletion) -> Void

    var body: some View {
        VStack(spacing: 1) {
            ForEach(suggestions, id: \.title) { suggestion in
                Button(action: { onSelect(suggestion) }) {
                    HStack(spacing: 12) {
                        Image(systemName: "mappin")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "C9A961"))
                            .frame(width: 20)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(suggestion.title)
                                .font(.system(size: 15, weight: .medium, design: .serif))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            if !suggestion.subtitle.isEmpty {
                                Text(suggestion.subtitle)
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(hex: "8B6F3F"))
                                    .lineLimit(1)
                            }
                        }

                        Spacer()

                        Image(systemName: "arrow.turn.up.right")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "8B6F3F").opacity(0.6))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }

                if suggestion.title != suggestions.last?.title {
                    Divider()
                        .background(Color(hex: "8B6F3F").opacity(0.2))
                        .padding(.leading, 48)
                }
            }
        }
        .background(Color.black.opacity(0.5))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "C9A961").opacity(0.4), lineWidth: 1)
        )
        .cornerRadius(14)
    }
}
//  PlaceSuggestionsView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

