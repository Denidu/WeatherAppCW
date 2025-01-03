//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weatherDataModel: WeatherDataModel?
    @Published var geoDataModel: GeoDataModel?
    @Published var errorMessage: String?
    private let apiClient = OpenweatherAPI()
    let locationManager = LocationManager()
    @Published var currentLocationName: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        locationManager.$currentLocation
            .sink { [weak self] location in
                if let location = location {
                    Task {
                        await self?.fetchWeatherData(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                        await self?.fetchLocationName(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                    }
                }
            }
            .store(in: &cancellables)
    }

    func fetchCurrentLocationWeather() {
        locationManager.requestLocation()
    }

    func fetchWeatherData(lat: Double, lon: Double) async {
        do {
            let rawData = try await withCheckedThrowingContinuation { continuation in
                apiClient.fetchWeather(lat: lat, lon: lon) { weatherData, error in
                    if let weatherData = weatherData {
                        continuation.resume(returning: weatherData)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    }
                }
            }
            await MainActor.run {
                self.weatherDataModel = rawData
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func fetchLocationName(lat: Double, lon: Double) async {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to get location name: \(error.localizedDescription)"
                }
            } else if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self?.currentLocationName = placemark.locality ?? "Unknown Location"
                }
            } else {
                DispatchQueue.main.async {
                    self?.currentLocationName = "Unknown Location"
                }
            }
        }
    }

    func handleLocationError(_ error: String) {
        self.errorMessage = error
    }

    func fetchGeoData(city: String, state: String, country: String, limit: Int = 1) async throws {
        do {
            let geoData = try await withCheckedThrowingContinuation { continuation in
                apiClient.fetchCoordinates(city: city, state: state, country: country, limit: limit) { geoDataModel, error in
                    if let geoDataModel = geoDataModel {
                        continuation.resume(returning: geoDataModel)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: NSError(domain: "GeoDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No geo data found for the provided location."]))
                    }
                }
            }

            await MainActor.run {
                self.geoDataModel = geoData
            }
            await fetchWeatherData(lat: geoData.lat, lon: geoData.lon)
        } catch let fetchError {
            await MainActor.run {
                self.errorMessage = fetchError.localizedDescription
            }
        }
    }
    
    func fetchWeatherForCity(city: String) async {
        do {
            let geoData = try await withCheckedThrowingContinuation { continuation in
                apiClient.fetchCoordinates(city: city, state: "", country: "", limit: 1) { geoDataModel, error in
                    if let geoDataModel = geoDataModel {
                        continuation.resume(returning: geoDataModel)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    }
                }
            }

            await fetchWeatherData(lat: geoData.lat, lon: geoData.lon)
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }

}
