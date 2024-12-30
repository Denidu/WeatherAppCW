//
//  HourlyWeatherCellView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct HourlyWeatherCellView: View {
    let hourlyWeatherData: WeatherDataModel
    
    var temperature: String {
        return "\(Int((hourlyWeatherData.hourly.first?.temp ?? 0)))°C"
    }
    
    var hour: String {
        return DateFormatterUtils.formattedDate12Hour(from: TimeInterval(hourlyWeatherData.hourly.first?.dt ?? 0))
    }
    
    var icon: String {
        return hourlyWeatherData.hourly.first?.weather.first?.icon ?? "default-icon"
    }
    
    var body: some View {
        VStack {
            Text(hour)
            Text("\(String(describing: hourlyWeatherData.hourly.first?.humidity ?? 0))%")
                .font(.system(size: 12))
                .foregroundColor(.init(red: 127/255, green: 1, blue: 212/255))
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text(temperature)
        }
        .padding(.all, 0)
    }
}

#Preview {
    HourlyWeatherCellView(hourlyWeatherData: WeatherDataModel.emptyInit())
}

