import MapKit
import Combine
import SwiftUI
import CoreLocation

class JourneyState: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var selectedPlace: MKMapItem?
    @Published var cameraPosition: MapCameraPosition = .userLocation(fallback: .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.9526, longitude: -75.1652),
            span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
        )
    ))
    @Published var route: MKRoute?
    @Published var eta: String = ""
    @Published var distance: String = ""

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        DispatchQueue.main.async {
            self.cameraPosition = .region(
                MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
                )
            )
        }
        locationManager.stopUpdatingLocation()
    }

    func selectPlace(_ suggestion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let item = response?.mapItems.first else { return }
            DispatchQueue.main.async {
                self?.selectedPlace = item
                self?.cameraPosition = .region(
                    MKCoordinateRegion(
                        center: item.placemark.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    )
                )
                self?.fetchRoute(to: item)
            }
        }
    }

    private func fetchRoute(to destination: MKMapItem) {
        let request = MKDirections.Request()
        request.source = .forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, _ in
            guard let route = response?.routes.first else { return }
            DispatchQueue.main.async {
                self?.route = route
                let minutes = Int(route.expectedTravelTime / 60)
                let miles = String(format: "%.1f", route.distance / 1609.34)
                self?.eta = "\(minutes) min"
                self?.distance = "\(miles) mi"
            }
        }
    }

    func startNavigation() {
        guard let place = selectedPlace else { return }
        let launchOptions: [String: Any] = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapTypeKey: MKMapType.mutedStandard.rawValue
        ]
        place.openInMaps(launchOptions: launchOptions)
    }
}
