import SwiftUI

struct ParkedView: View {
    @State private var selectedTab: ParkedTab = .home

    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "0D0A07").ignoresSafeArea()

            VStack(spacing: 0) {

                // ── STATUS BAR
                StatusBarView(mode: .parked)

                // ── CONTENT
                ZStack {
                    switch selectedTab {
                    case .home:
                        HomeTabView()
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .transition(.opacity)
                    case .journey:
                        JourneyView()
                            .transition(.opacity)
                    case .audio:
                        AudioView()
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .transition(.opacity)
                    case .journal:
                        PlaceholderTabView(title: "Journal", icon: "mic")
                            .transition(.opacity)
                    case .study:
                        PlaceholderTabView(title: "Study", icon: "book")
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // ── TAB BAR
                TabBarView(selectedTab: $selectedTab)
                    .padding(.bottom, 16)
            }
        }
    }
}

// Placeholder for tabs not built yet
struct PlaceholderTabView: View {
    var title: String
    var icon: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(Color(hex: "8B6F3F"))
            Text(title)
                .font(.system(size: 28, weight: .thin, design: .serif))
                .foregroundColor(.white)
                .italic()
            Text("Coming soon")
                .font(.system(size: 10, weight: .semibold))
                .tracking(4)
                .foregroundColor(Color(hex: "8B6F3F"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeTabView: View {
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 10) {
            GreetingView()
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: appeared)

            VehicleHeroView()
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.2), value: appeared)

            ContinueListeningCard()
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.3), value: appeared)

            InfoCardsView()
                .frame(height: 130)
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.4), value: appeared)
        }
        .onAppear { appeared = true }
        .onDisappear { appeared = false }
    }
}
