//
//  DailyWeatherView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct DailyWeatherView: View {
    let weatherData: [WeatherDataModel]
    
    var body: some View {
        VStack {
            ForEach(weatherData) { data in
                DailyWeatherCellView(weatherData: data)
            }
        }
    }
}

#Preview {
    DailyWeatherView(weatherData: [WeatherDataModel.emptyInit()])
}

