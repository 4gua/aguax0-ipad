import MapKit
import SwiftUI

struct HomeDashboardView: View {
    @EnvironmentObject private var locationManager: LocationManager
    let mode: VehicleMode
    let transitionMessage: String?

    private var regionBinding: Binding<MKCoordinateRegion> {
        Binding(
            get: { locationManager.region },
            set: { locationManager.region = $0 }
        )
    }

    var body: some View {
        HStack(spacing: 18) {
            VStack(spacing: 18) {
                vehicleSpotlight
                mediaStrip
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 18) {
                liveMapCard
                nativeStatusCard
            }
            .frame(width: 320)
        }
    }

    private var vehicleSpotlight: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Honda Fit")
                        .font(.system(size: 34, weight: .regular, design: .serif))
                        .foregroundStyle(AguaTheme.cream)
                    Text("Connected cockpit for iPad mini 6")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .tracking(2.2)
                        .foregroundStyle(AguaTheme.bronze)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Text("LIVE SPEED")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .tracking(2.2)
                        .foregroundStyle(AguaTheme.bronze)
                    Text("\(Int(locationManager.speedMPH.rounded())) mph")
                        .font(.system(size: 22, weight: .light, design: .serif))
                        .foregroundStyle(locationManager.speedMPH > 35 ? AguaTheme.danger : AguaTheme.gold)
                }
            }

            Spacer(minLength: 0)

            VehicleShowcaseView(mode: mode, transitionMessage: transitionMessage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack(spacing: 12) {
                statusPill("Locked", systemImage: "checkmark.shield.fill", tint: AguaTheme.green)
                statusPill("Cabin 72°", systemImage: "thermometer.medium", tint: AguaTheme.gold)
                statusPill(mode == .driving ? "Driving" : "Parked", systemImage: mode == .driving ? "location.north.line.fill" : "parkingsign.circle.fill", tint: AguaTheme.goldSoft)
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aguaCard()
    }

    private var mediaStrip: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [AguaTheme.gold, AguaTheme.bronze],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.black.opacity(0.75))
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 6) {
                Text("Continue Listening".uppercased())
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(AguaTheme.gold)
                Text("The Huberman Lab · Ep 184")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundStyle(AguaTheme.cream)
                ProgressView(value: 0.62)
                    .tint(AguaTheme.gold)
            }

            Spacer()

            Button {} label: {
                Image(systemName: "play.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(width: 44, height: 44)
                    .background(AguaTheme.gold, in: Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .aguaCard()
    }

    private var liveMapCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Map".uppercased())
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(AguaTheme.bronze)
                Spacer()
                if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
                    Text("GPS Ready")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(AguaTheme.gold)
                } else {
                    Button("Enable Location") {
                        locationManager.requestPermission()
                    }
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(AguaTheme.gold)
                }
            }

            Map(coordinateRegion: regionBinding, showsUserLocation: true)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .frame(height: 220)

            Text(locationManager.coordinateLabel)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(AguaTheme.cream.opacity(0.72))
        }
        .padding(18)
        .aguaCard()
    }

    private var nativeStatusCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Vehicle Systems".uppercased())
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .tracking(2)
                .foregroundStyle(AguaTheme.bronze)

            NativeServiceRow(title: "Location", detail: locationManager.statusLabel, symbol: "location.circle.fill", tint: AguaTheme.gold)
            NativeServiceRow(title: "Maps", detail: "Live user map and journey surface", symbol: "map.fill", tint: AguaTheme.goldSoft)
            NativeServiceRow(title: "Voice", detail: "Memo recording and media controls next", symbol: "mic.fill", tint: AguaTheme.gold)
            NativeServiceRow(title: "Platform", detail: "Native SwiftUI shell for iPad mini", symbol: "ipad.landscape", tint: AguaTheme.green)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .aguaCard()
    }

    private func statusPill(_ text: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(tint)
            Text(text.uppercased())
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .tracking(2)
                .foregroundStyle(AguaTheme.cream)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05), in: Capsule(style: .continuous))
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

private struct VehicleShowcaseView: View {
    let mode: VehicleMode
    let transitionMessage: String?

    @State private var parkedSceneIndex = 0

    private let parkedScenes = [
        "showcase-front",
        "showcase-rear",
        "showcase-profile",
    ]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if mode == .parked {
                    ForEach(parkedScenes.indices, id: \.self) { index in
                        Image(parkedScenes[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .clipped()
                            .opacity(parkedSceneIndex == index ? 1 : 0)
                            .scaleEffect(parkedSceneIndex == index ? 1.02 : 1.08)
                            .offset(x: parkedSceneIndex == index ? 0 : 12, y: parkedSceneIndex == index ? 0 : 4)
                            .animation(.easeInOut(duration: 1.0), value: parkedSceneIndex)
                    }
                } else {
                    Image("showcase-drive")
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                        .scaleEffect(1.06)
                        .offset(x: 14, y: 4)

                    MotionStreaksOverlay()
                        .blendMode(.screen)
                }

                Rectangle()
                    .fill(.ultraThinMaterial.opacity(mode == .driving ? 0.14 : 0.08))

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.44),
                        Color.black.opacity(0.08),
                        Color.black.opacity(0.36)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.16),
                        Color.clear,
                        Color.black.opacity(0.58)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                EmbeddedModelViewer(mode: mode)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .shadow(color: .black.opacity(0.28), radius: 24, y: 10)
                    .scaleEffect(mode == .driving ? 1.03 : 1.0)
                    .animation(.easeInOut(duration: 0.45), value: mode)

                VStack {
                    HStack {
                        Text(mode == .driving ? "DRIVING" : "PARKED")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .tracking(3)
                            .foregroundStyle(AguaTheme.gold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.black.opacity(0.18), in: Capsule(style: .continuous))
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
                            )
                        Spacer()
                    }

                    Spacer()

                    EmptyView()
                }
                .padding(22)

                if let transitionMessage {
                    VStack(spacing: 10) {
                        Text("Agua X0")
                            .font(.system(size: 34, weight: .regular, design: .serif))
                            .foregroundStyle(AguaTheme.cream)
                        Text(transitionMessage.uppercased())
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .tracking(4)
                            .foregroundStyle(AguaTheme.gold)
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 18)
                    .background(.black.opacity(0.28), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(AguaTheme.gold.opacity(0.28), lineWidth: 1)
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.18), radius: 30, y: 16)
            .onReceive(Timer.publish(every: 4.6, on: .main, in: .common).autoconnect()) { _ in
                guard mode == .parked else { return }
                withAnimation(.easeInOut(duration: 1.0)) {
                    parkedSceneIndex = (parkedSceneIndex + 1) % parkedScenes.count
                }
            }
        }
    }
}

private struct MotionStreaksOverlay: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 999, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, AguaTheme.gold.opacity(0.18), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: proxy.size.width * 0.55, height: 3)
                        .rotationEffect(.degrees(-12))
                        .offset(
                            x: animate ? proxy.size.width * 0.32 : -proxy.size.width * 0.32,
                            y: CGFloat(index * 34) - 54
                        )
                        .animation(.linear(duration: 1.25).repeatForever(autoreverses: false).delay(Double(index) * 0.12), value: animate)
                }
            }
            .onAppear {
                animate = true
            }
        }
    }
}

private struct NativeServiceRow: View {
    let title: String
    let detail: String
    let symbol: String
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 28, height: 28)
                .background(tint.opacity(0.15), in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(AguaTheme.cream)
                Text(detail)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(AguaTheme.cream.opacity(0.68))
            }

            Spacer()
        }
    }
}
