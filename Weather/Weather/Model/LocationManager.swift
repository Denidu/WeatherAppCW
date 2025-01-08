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
    @Published var existingLocation: CLLocation?
    @Published var locationError: Error?
    @Published var isRequesting = false
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func requestLocation() {
        guard !isRequesting else { return }
        isRequesting = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if self.existingLocation == nil {
                    self.locationError = NSError(domain: "LocationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch location. Please try again."])
                    self.isRequesting = false
                }
            }
        } else {
            locationError = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location services are disabled."])
            isRequesting = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        existingLocation = location
        isRequesting = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied."])
            case .locationUnknown:
                locationError = NSError(domain: "LocationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch location. Please try again."])
            case .network:
                locationError = NSError(domain: "LocationError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Network issue while fetching location."])
            default:
                locationError = NSError(domain: "LocationError", code: 0, userInfo: [NSLocalizedDescriptionKey: clError.localizedDescription])
            }
        } else {
            print("Unknown location error: \(error.localizedDescription)")
            locationError = error
        }
        isRequesting = false
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            locationError = NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permission denied."])
        case .notDetermined:
            print("Authorization not determined yet")
        default:
            break
        }
    }
}
