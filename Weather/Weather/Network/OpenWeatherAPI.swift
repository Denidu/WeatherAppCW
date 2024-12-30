//
//  OpenWeatherAPI.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import Foundation
import Alamofire

class OpenweatherAPI {
    typealias WeatherCompletionHandler = (WeatherDataModel?, Error?) -> Void
    typealias GeoCompletionHandler = (GeoDataModel?, Error?) -> Void
    
    private let apiKey = "fcf4c07675ec77204b1bf07ee7020888"

    private func createWeatherURL(lat: Double, lon: Double, exclude: String? = nil) -> String {
        let baseURL = "https://api.openweathermap.org/data/3.0/onecall"
        var url = "\(baseURL)?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        
        if let exclude = exclude {
            url += "&exclude=\(exclude)"
        } else {
            url += "&exclude=current,minutely,hourly,daily,alerts"
        }
        
        return url
    }

    private func createGeoURL(city: String, state: String? = nil, country: String? = nil, limit: Int = 1) -> String {
        var components = ["https://api.openweathermap.org/geo/1.0/direct?q=\(city)"]
        
        if let state = state, !state.isEmpty {
            components.append(state)
        }
        if let country = country, !country.isEmpty {
            components.append(country)
        }
        
        let query = components.joined(separator: ",")
        return "\(query)&limit=\(limit)&appid=\(apiKey)"
    }

    func fetchWeather(lat: Double, lon: Double, exclude: String = "minutely", completion: @escaping WeatherCompletionHandler) {
        let url = createWeatherURL(lat: lat, lon: lon, exclude: exclude)
        
        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let rawResponse = String(data: data, encoding: .utf8) {
                        print("Raw response: \(rawResponse)")                     }
                    let decodedData = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                    completion(decodedData, nil)
                } catch let decodingError {
                    print("Decoding error: \(decodingError.localizedDescription)")
                    completion(nil, decodingError)
                }
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }

    func fetchCoordinates(city: String, state: String, country: String, limit: Int = 1, completion: @escaping GeoCompletionHandler) {
        let url = createGeoURL(city: city, state: state, country: country, limit: limit)
        
        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let rawResponse = String(data: data, encoding: .utf8) {
                        print("Raw response: \(rawResponse)")  // Debugging print
                    }
                    let decodedData = try JSONDecoder().decode([GeoDataModel].self, from: data)
                    completion(decodedData.first, nil)
                } catch let decodingError {
                    print("Decoding error: \(decodingError.localizedDescription)")
                    completion(nil, decodingError)
                }
            case .failure(let error):
                print("Error fetching geo data: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
}

