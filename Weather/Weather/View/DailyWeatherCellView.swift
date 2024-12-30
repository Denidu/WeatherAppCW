//
//  DailyWeatherCellView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct DailyWeatherCellView: View {
    let weatherData: WeatherDataModel
    
    var temperatureMax: String {
        return "\(Int((weatherData.daily.first?.temp.max ?? 0)))°C"
    }

    var temperatureMin: String {
        return "\(Int((weatherData.daily.first?.temp.min ?? 0)))°C"
    }

    var day: String {
        return DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(weatherData.daily.first?.dt ?? 0))
    }

    var icon: String {
        return weatherData.daily.first?.weather.first?.icon ?? "default-icon"
    }
    
    var body: some View {
        HStack {
            Text(day)
                .frame(width: 150, alignment: .leading)

            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)

            Spacer()
            Text(temperatureMax)
            Spacer().frame(width: 34)
            Text(temperatureMin)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    DailyWeatherCellView(weatherData: WeatherDataModel.emptyInit())
}

