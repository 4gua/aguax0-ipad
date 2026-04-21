import SwiftUI

struct ParkedView: View {
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.03, blue: 0.02)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Sanctuary")
                    .font(.system(size: 48, weight: .thin, design: .serif))
                    .foregroundColor(.white)
                    .italic()

                Text("PARKED")
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(8)
                    .foregroundColor(Color(hex: "8B6F3F"))
            }
        }
    }
}
//  ParkedView.swift.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

