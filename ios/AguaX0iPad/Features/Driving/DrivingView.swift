import SwiftUI

struct DrivingView: View {
    var speed: Double

    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "0D0A07").ignoresSafeArea()

            VStack(spacing: 0) {

                // ── STATUS BAR
                StatusBarView(mode: .driving)

                // ── NEXT TURN STRIP
                TurnStripView()

                // ── MAIN ROW
                HStack(spacing: 16) {

                    // LEFT: Speedometer + speed limit
                    VStack(spacing: 12) {
                        SpeedometerView(speed: speed)
                        SpeedLimitBadge(limit: 35, current: speed)
                    }
                    .frame(width: 300)

                    // CENTER: Map
                    MapPlaceholderView()

                    // RIGHT: Media + ETA + Voice
                    VStack(spacing: 10) {
                        NowPlayingCard()
                        ETACard()
                        VoiceMemoButton()
                    }
                    .frame(width: 220)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
