import SwiftUI

struct GreetingView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greetingText())
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(5)
                    .foregroundColor(Color(hex: "C9A961"))
                Text(dayName())
                    .font(.system(size: 28, weight: .thin, design: .serif))
                    .foregroundColor(.white)
                    .italic()
                Text(dateLong())
                    .font(.system(size: 16, weight: .thin, design: .serif))
                    .foregroundColor(.white.opacity(0.65))
            }
            Spacer()
        }
    }

    private func greetingText() -> String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "Good Morning" }
        if h < 18 { return "Good Afternoon" }
        return "Good Evening"
    }

    private func dayName() -> String {
        Date().formatted(.dateTime.weekday(.wide))
    }

    private func dateLong() -> String {
        Date().formatted(.dateTime.month(.wide).day().year())
    }
}
//  GreetingView.swift
//  AguaX0iPad
//
//  Created by MrClaver on 4/21/26.
//

