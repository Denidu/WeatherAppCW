//
//  LocationManager.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    @Published var currentLocation: CLLocation?
    @Published var locationError: Error?
    @Published var isRequestInProgress = false
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func requestLocation() {
        guard !isRequestInProgress else { return }
        isRequestInProgress = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            
            // Timeout fallback after 10 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if self.currentLocation == nil {
                    self.locationError = NSError(domain: "LocationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch location. Please try again."])
                    self.isRequestInProgress = false
                }
            }
        } else {
            locationError = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services are disabled."])
            isRequestInProgress = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("No location found") // Debugging log
            return
        }
        print("Updated Location: \(location.coordinate.latitude), \(location.coordinate.longitude)") // Debugging log
        currentLocation = location
        isRequestInProgress = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("Location access denied")
                locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied."])
            case .locationUnknown:
                print("Location is currently unknown")
                locationError = NSError(domain: "LocationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch location. Please try again."])
            case .network:
                print("Network issue while fetching location")
                locationError = NSError(domain: "LocationError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Network issue while fetching location."])
            default:
                print("Unexpected Core Location error: \(clError.localizedDescription)")
                locationError = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: clError.localizedDescription])
            }
        } else {
            print("Unknown location error: \(error.localizedDescription)")
            locationError = error
        }
        isRequestInProgress = false
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Authorization granted")
            locationManager.requestLocation()
        case .denied, .restricted:
            print("Authorization denied or restricted")
            locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permission denied."])
        case .notDetermined:
            print("Authorization not determined yet")
        default:
            break
        }
    }


}
