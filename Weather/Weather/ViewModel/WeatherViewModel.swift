//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import Foundation
import CoreLocation
import SwiftUICore

class WeatherViewModel: ObservableObject {
    
    @Published var weatherDataModel: WeatherDataModel?
    @Published var geoDataModel: GeoDataModel?
    @Published var errorMessage: String?
    
    private let apiClient = OpenweatherAPI()
    
    func fetchWeatherForCurrentLocation(lat: Double, lon: Double) async {
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
            self.weatherDataModel = weatherData
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchWeatherData(lat: Double, lon: Double) async throws {
        do {
            let weatherData = try await withCheckedThrowingContinuation { continuation in
                apiClient.fetchWeather(lat: lat, lon: lon) { weatherData, error in
                    if let weatherData = weatherData {
                        print("Fetched Weather Data: \(weatherData)")  // Debugging line
                        continuation.resume(returning: weatherData)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    }
                }
            }
            self.weatherDataModel = weatherData
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func fetchGeoData(city: String, state: String, country: String, limit: Int = 1) async {
        do {
            let geoData = try await withCheckedThrowingContinuation { continuation in
                apiClient.fetchCoordinates(city: city, state: state, country: country, limit: limit) { geoDataModel, error in
                    if let geoDataModel = geoDataModel {
                        print("Fetched Geo Data: \(geoDataModel)")  // Debugging line
                        continuation.resume(returning: geoDataModel)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: NSError(domain: "GeoDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No geo data found for the provided location."]))
                    }
                }
            }
            
            let lat = geoData.lat
            let lon = geoData.lon
            try await fetchWeatherData(lat: lat, lon: lon)
            
            DispatchQueue.main.async {
                self.geoDataModel = geoData
            }
            
        } catch let fetchError {
            DispatchQueue.main.async {
                self.errorMessage = fetchError.localizedDescription
            }
        }
    }
}
