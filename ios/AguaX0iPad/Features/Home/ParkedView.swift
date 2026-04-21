import SwiftUI

struct ParkedView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "0D0A07").ignoresSafeArea()

            VStack(spacing: 0) {
                StatusBarView(mode: .parked)

                Spacer()

                VStack(spacing: 8) {
                    Text("Sanctuary")
                        .font(.system(size: 48, weight: .thin, design: .serif))
                        .foregroundColor(.white)
                        .italic()
                    Text("PARKED")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(8)
                        .foregroundColor(Color(hex: "8B6F3F"))
                }

                Spacer()
            }
        }
    }
}
