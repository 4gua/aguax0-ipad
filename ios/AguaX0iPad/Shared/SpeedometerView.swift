import SwiftUI

struct SpeedometerView: View {
    var speed: Double
    
    private let maxSpeed: Double = 100
    private let startAngle: Double = -225
    private let endAngle: Double = 45
    
    private var progressAngle: Double {
        let pct = min(speed / maxSpeed, 1.0)
        return startAngle + pct * (endAngle - startAngle)
    }
    
    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                .padding(20)
            
            // Track arc
            Arc(startAngle: startAngle, endAngle: endAngle)
                .stroke(Color.white.opacity(0.08), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .padding(28)
            
            // Active arc
            Arc(startAngle: startAngle, endAngle: progressAngle)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "E8CF95"), Color(hex: "8B6F3F")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .padding(28)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: speed)
            
            // Tick marks
            ForEach(0..<11) { i in
                TickMark(index: i, total: 10, startAngle: startAngle, endAngle: endAngle)
            }
            
            // Needle
            NeedleView(angle: progressAngle)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: speed)
            
            // Center hub
            Circle()
                .fill(Color(hex: "0D0A07"))
                .frame(width: 16, height: 16)
                .overlay(Circle().stroke(Color(hex: "C9A961"), lineWidth: 1))
            Circle()
                .fill(Color(hex: "C9A961"))
                .frame(width: 5, height: 5)
            
            // Speed number
            VStack(spacing: 4) {
                Spacer()
                Text("\(Int(speed))")
                    .font(.system(size: 72, weight: .light, design: .serif))
                    .foregroundColor(.white)
                    .monospacedDigit()
                Text("MPH")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(6)
                    .foregroundColor(Color(hex: "8B6F3F"))
                Spacer().frame(height: 60)
            }
        }
        .frame(width: 340, height: 340)
    }
}

// MARK: - Arc Shape
struct Arc: Shape {
    var startAngle: Double
    var endAngle: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(startAngle),
            endAngle: .degrees(endAngle),
            clockwise: false
        )
        return path
    }
}

// MARK: - Tick Mark
struct TickMark: View {
    var index: Int
    var total: Int
    var startAngle: Double
    var endAngle: Double
    
    var body: some View {
        let angle = startAngle + Double(index) / Double(total) * (endAngle - startAngle)
        let isMajor = index % 2 == 0
        return Rectangle()
            .fill(Color.white.opacity(isMajor ? 0.7 : 0.3))
            .frame(width: isMajor ? 1.5 : 0.8, height: isMajor ? 12 : 7)
            .offset(y: -130)
            .rotationEffect(.degrees(angle + 90))
    }
}

// MARK: - Needle
struct NeedleView: View {
    var angle: Double
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color(hex: "E8CF95"), Color(hex: "C9A961")],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 2, height: 110)
            .offset(y: -55)
            .rotationEffect(.degrees(angle + 90))
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
