//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import Foundation
import CoreLocation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherDataModel: WeatherDataModel?
    @Published var geoDataModel: GeoDataModel?
    @Published var errorMessage: String?

    private let apiClient = OpenweatherAPI()
    private let locationManager = LocationManager()

    init(weatherData: WeatherDataModel? = nil, geoData: GeoDataModel? = nil) {
        self.weatherDataModel = weatherData
        self.geoDataModel = geoData

        locationManager.onLocationUpdate = { [weak self] location in
            Task {
                await self?.fetchWeatherData(lat: location.latitude, lon: location.longitude)
            }
        }
    }

    func fetchCurrentLocationWeather() {
        locationManager.requestLocation()
    }

    func fetchWeatherData(lat: Double, lon: Double) async {
        do {
            let weatherData = try await withCheckedThrowingContinuation { continuation in
                apiClient.fetchWeather(lat: lat, lon: lon) { weatherData, error in
                    if let weatherData = weatherData {
                        continuation.resume(returning: weatherData)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    }
                }
            }

            await MainActor.run {
                self.weatherDataModel = weatherData
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
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

    func getWeatherDataForUI() -> (geoData: GeoDataModel?, weatherData: WeatherDataModel?) {
        return (geoDataModel, weatherDataModel)
    }
}
