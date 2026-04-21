import SwiftUI

struct MapPlaceholderView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(hex: "0A0603"))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "8B6F3F").opacity(0.4), lineWidth: 1)
            )
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "map")
                        .font(.system(size: 28))
                        .foregroundColor(Color(hex: "8B6F3F"))
                    Text("MAP")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(4)
                        .foregroundColor(Color(hex: "8B6F3F").opacity(0.6))
                    Text("MapKit coming next")
                        .font(.system(size: 9))
                        .foregroundColor(Color(hex: "8B6F3F").opacity(0.4))
                }
            )
    }
}
//  MapPlaceholderView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

