import SwiftUI

enum AguaTheme {
    static let background = LinearGradient(
        colors: [
            Color(red: 0.10, green: 0.07, blue: 0.04),
            Color(red: 0.04, green: 0.03, blue: 0.02),
            .black
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let gold = Color(red: 0.79, green: 0.66, blue: 0.38)
    static let goldSoft = Color(red: 0.91, green: 0.82, blue: 0.58)
    static let cream = Color(red: 0.94, green: 0.90, blue: 0.82)
    static let bronze = Color(red: 0.55, green: 0.44, blue: 0.25)
    static let danger = Color(red: 0.85, green: 0.35, blue: 0.24)
    static let green = Color(red: 0.42, green: 0.69, blue: 0.48)
    static let card = Color.white.opacity(0.05)
    static let cardStrong = Color.white.opacity(0.08)
    static let stroke = Color.white.opacity(0.10)
}

struct AguaCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AguaTheme.card, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(AguaTheme.stroke, lineWidth: 1)
            )
    }
}

extension View {
    func aguaCard() -> some View {
        modifier(AguaCardModifier())
    }
}
