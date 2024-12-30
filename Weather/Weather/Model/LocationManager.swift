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

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    func requestLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            errorMessage = "Location services are disabled. Please enable them in Settings."
            print("Location services are disabled.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                print("Location updated: \(location)")
                self.currentLocation = location.coordinate
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                
                self.onLocationUpdate?(location.coordinate)

                Task {
                    try await self.weatherViewModel?.fetchWeatherData(lat: lat, lon: lon)
                }
                self.reverseGeocode(location: location)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Failed to get your location: \(error.localizedDescription)"
            print("Location fetching error: \(error.localizedDescription)")
        }
    }

    private func reverseGeocode(location: CLLocation) {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                    }
                } else if let placemark = placemarks?.first {
                    DispatchQueue.main.async {
                        self?.locationName = placemark.locality ?? "Unknown Location"
                    }
                }
            }
        }
    }
