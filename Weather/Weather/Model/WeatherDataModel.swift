//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import Foundation

struct WeatherDataModel: Codable, Identifiable {
    let id = UUID()
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let minutely: [Minutely]?
    let hourly: [Current]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, minutely, hourly, daily
    }
    
    static func emptyInit() -> WeatherDataModel {
        return WeatherDataModel(
            lat: 0.0,
            lon: 0.0,
            timezone: "",
            timezoneOffset: 0,
            current: Current.emptyInit(),
            minutely: [],
            hourly: [],
            daily: []
        )
    }
    
}

// MARK: - Current
struct Current: Codable, Identifiable {
    let id = UUID()
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let windGust, pop: Double?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop, rain
    }
    
    static func emptyInit() -> Current {
        return Current(
            dt: 0,
            sunrise: nil,
            sunset: nil,
            temp: 0.0,
            feelsLike: 0.0,
            pressure: 0,
            humidity: 0,
            dewPoint: 0.0,
            uvi: 0.0,
            clouds: 0,
            visibility: 0,
            windSpeed: 0.0,
            windDeg: 0,
            weather: [],
            windGust: nil,
            pop: nil,
            rain: nil
        )
    }
}

// MARK: - Rain
struct Rain: Codable{
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
    static func emptyInit() -> Rain {
        return Rain(the1H: 0.0)
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: Main
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main, description, icon
    }

    static func emptyInit() -> Weather {
        return Weather(
            id: 0,
            main: .clear,
            description: "", 
            icon: ""
        )
    }
}


enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case mist = "Mist"
    case smoke = "Smoke"
    case haze = "Haze"
    case dust = "Dust"
    case fog = "Fog"
    case sand = "Sand"
    case ash = "Ash"
    case squall = "Squall"
    case tornado = "Tornado"
    case snow = "Snow"
    case drizzle = "Drizzle"
    case thunderstorm = "Thunderstorm"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
    case thunderstormWithLightRain = "thunderstorm with light rain"
    case thunderstormWithRain = "thunderstorm with rain"
    case thunderstormWithHeavyRain = "thunderstorm with heavy rain"
    case lightThunderstorm = "light thunderstorm"
    case thunderstorm = "thunderstorm"
    case heavyThunderstorm = "heavy thunderstorm"
    case raggedThunderstorm = "ragged thunderstorm"
    case thunderstormWithLightDrizzle = "thunderstorm with light drizzle"
    case thunderstormWithDrizzle = "thunderstorm with drizzle"
    case thunderstormWithHeavyDrizzle = "thunderstorm with heavy drizzle"
    case heavyIntensityDrizzle = "heavy intensity drizzle"
    case lightIntensityDrizzleRain = "light intensity drizzle rain"
    case drizzleRain = "drizzle rain"
    case heavyIntensityDrizzleRain = "heavy intensity drizzle rain"
    case showerRainAndDrizzle = "shower rain and drizzle"
    case heavyShowerRainAndDrizzle = "heavy shower rain and drizzle"
    case showerDrizzle = "shower drizzle"
    case heavyIntensityRain = "heavy intensity rain"
    case veryHeavyRain = "very heavy rain"
    case extremeRain = "exteme rain"
    case freezingRain = "freezing rain"
    case lightIntensityShowerRain = "light intensity shower rain"
    case showerRain = "shower rain"
    case heavyIntensityShowerRain = "heavy intensity shower rain"
    case raggedShowerRain = "ragged shower rain"
    case lightSnow = "light snow"
    case Snow = "Snow"
    case RainAndSnow = "rain and snow"
    case HeavySnow = "Heavy snow"
    case Sleet = "Sleet"
    case LightShowerSleet = "Light shower sleet"
    case ShowerSleet = "Shower sleet"
    case LightRainAndSnow = "Light rain and snow"
    case LightShowerSnow = "Light shower snow"
    case ShowerSnow = "Shower snow"
    case HeavyShowerSnow = "Heavy shower snow"
    case mist = "mist"
    case Smoke = "Smoke"
    case Haze = "Haze"
    case sandDustWhirls = "sand/dust whirls"
    case fog = "fog"
    case sand = "sand"
    case dust = "dXust"
    case volcanicAsh = "volcanic ash"
    case squalls = "squalls"
    case tornado = "tornado"
    case fewClouds1125 = "few clouds: 11-25%"
    case scatteredClouds2550 = "scattered clouds: 25-50%"
    case brokenClouds5184 = "broken clouds: 51-84%"
    case overcastClouds85100 = "overcast clouds: 85-100%"
}

// MARK: - Daily
struct Daily: Codable, Identifiable {
    let id = UUID()
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
    }
    static func emptyInit() -> Daily {
        return Daily(
            dt: 0,
            sunrise: 0,
            sunset: 0,
            moonrise: 0,
            moonset: 0,
            moonPhase: 0.0,
            temp: Temp.emptyInit(),
            feelsLike: FeelsLike.emptyInit(),
            pressure: 0,
            humidity: 0,
            dewPoint: 0.0,
            windSpeed: 0.0,
            windDeg: 0,
            windGust: 0.0,
            weather: [],
            clouds: 0,
            pop: 0.0,
            rain: nil,
            uvi: 0.0
        )
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable{
    let day, night, eve, morn: Double
    
    enum CodingKeys: String, CodingKey{
        case day, night, eve, morn
    }
    static func emptyInit() -> FeelsLike {
        return FeelsLike(day: 0.0, night: 0.0, eve: 0.0, morn: 0.0)
    }
}

// MARK: - Temp
struct Temp: Codable{
    let day, min, max, night: Double
    let eve, morn: Double
    
    enum CodingKeys: String, CodingKey {
       case day, min, max,night, eve, morn
    }
    static func emptyInit() -> Temp {
       return Temp(day: 0.0, min: 0.0, max: 0.0, night: 0.0, eve: 0.0, morn: 0.0)
   }
}

// MARK: - Minutely
struct Minutely: Codable {
    let dt: Int
    let precipitation: Double
    
    enum CodingKeys: String, CodingKey{
        case dt, precipitation
    }
    static func emptyInit() -> Minutely {
        return Minutely(dt: 0, precipitation: 0.0)
    }
    
}



