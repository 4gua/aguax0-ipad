import CoreLocation
import MapKit

@MainActor
final class LocationManager: NSObject, ObservableObject, @preconcurrency CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var lastLocation: CLLocation?
    @Published var speedMPH: Double = 0
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0195, longitude: -118.4912),
        span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
    )

    private let manager = CLLocationManager()

    func start() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    var statusLabel: String {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return "Live GPS"
        case .denied, .restricted:
            return "Location Off"
        case .notDetermined:
            return "Permission Needed"
        @unknown default:
            return "Location"
        }
    }

    var coordinateLabel: String {
        guard let location = lastLocation else {
            return "Waiting for a fix"
        }

        return String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        lastLocation = location
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )

        if location.speed >= 0 {
            speedMPH = location.speed * 2.23693629
        }
    }
}
