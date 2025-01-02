//
//  LocationManager.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//


import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var locationName: String?
    @Published var errorMessage: String?
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var weatherViewModel: WeatherViewModel?
    private var isRequestingLocation = false
    private var isUpdatingWeather = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        print("LocationManager initialized and authorization requested.")
    }

    func requestLocation() {
        guard !isRequestingLocation else {
            print("Location request is already in progress.")
            return
        }

        if CLLocationManager.locationServicesEnabled() {
            isRequestingLocation = true
            print("Requesting location update.")
            locationManager.requestLocation()
        } else {
            errorMessage = "Location services are disabled. Please enable them in Settings."
            print("Location services are disabled.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed: \(status.rawValue)")
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Authorization granted. Requesting location.")
            requestLocation()
        case .denied, .restricted:
            errorMessage = "Location access is denied. Please enable it in Settings."
            print("Location access denied.")
        case .notDetermined:
            print("Authorization not determined. Requesting authorization.")
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isRequestingLocation = false

        guard !isUpdatingWeather, let location = locations.last else { return }
        print("Location updated: Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")

        currentLocation = location.coordinate
        reverseGeocode(location: location)

        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        Task {
            do {
                print("Fetching weather data for lat: \(lat), lon: \(lon)")
                 await weatherViewModel?.fetchWeatherData(lat: lat, lon: lon)
                print("Weather update completed.")
            } catch {
                print("Weather fetch failed: \(error.localizedDescription)")
            }
            isUpdatingWeather = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRequestingLocation = false
        errorMessage = "Failed to get your location: \(error.localizedDescription)"
        print("Location fetching error: \(error.localizedDescription) (\(error as NSError).code)")
    }

    private func reverseGeocode(location: CLLocation) {
        print("Starting reverse geocoding for location: \(location)")
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                self?.errorMessage = "Reverse geocoding failed: \(error.localizedDescription)"
                print("Reverse geocoding failed: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                let locationName = placemark.locality ?? "Unknown Location"
                self?.locationName = locationName
                print("Reverse geocoding succeeded. Location name: \(locationName)")
            }
        }
    }
}
