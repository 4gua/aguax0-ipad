import SwiftUI
import MapKit

struct LiveMapView: View {
    @ObservedObject var journeyState: JourneyState

    var body: some View {
        ZStack {
            Map(position: Binding(
                get: { journeyState.cameraPosition },
                set: { journeyState.cameraPosition = $0 }
            )) {
                UserAnnotation()
                if let place = journeyState.selectedPlace {
                    Marker(
                        place.name ?? "Destination",
                        coordinate: place.placemark.coordinate
                    )
                    .tint(Color(hex: "C9A961"))
                }
                if let route = journeyState.route {
                    MapPolyline(route.polyline)
                        .stroke(Color(hex: "C9A961"), lineWidth: 3)
                }
            }
            .colorScheme(.dark)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "8B6F3F").opacity(0.4), lineWidth: 1)
            )

            // Gradient overlay
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.black.opacity(0.3), Color.clear, Color.black.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack {
                HStack {
                    // Current location button
                    Button(action: {
                        journeyState.cameraPosition = .userLocation(
                            fallback: .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 39.9526, longitude: -75.1652),
                                span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
                            ))
                        )
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "C9A961"))
                            Text("CURRENT LOCATION")
                                .font(.system(size: 9, weight: .semibold))
                                .tracking(3)
                                .foregroundColor(Color(hex: "C9A961"))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(20)
                    }
                    Spacer()
                }
                .padding(12)

                Spacer()

                // Route info + Go button
                if let place = journeyState.selectedPlace {
                    VStack(spacing: 8) {
                        if !journeyState.eta.isEmpty {
                            HStack(spacing: 16) {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 10))
                                    Text(journeyState.eta)
                                        .font(.system(size: 13, weight: .medium, design: .serif))
                                }
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.forward")
                                        .font(.system(size: 10))
                                    Text(journeyState.distance)
                                        .font(.system(size: 13, weight: .medium, design: .serif))
                                }
                            }
                            .foregroundColor(Color(hex: "C9A961"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(20)
                        }

                        Button(action: { journeyState.startNavigation() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.turn.up.right")
                                    .font(.system(size: 13))
                                Text("Go to \(place.name ?? "destination")")
                                    .font(.system(size: 14, weight: .medium, design: .serif))
                            }
                            .foregroundColor(Color(hex: "0D0A07"))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(hex: "C9A961"))
                            .cornerRadius(24)
                            .shadow(color: Color(hex: "C9A961").opacity(0.4), radius: 12)
                        }
                    }
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .cornerRadius(16)
        .animation(.easeInOut(duration: 0.3), value: journeyState.selectedPlace?.name)
    }
}
