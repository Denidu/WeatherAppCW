//
//  HourlyWeatherView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct HourlyWeatherView: View {
    let hourlyWeatherData: [WeatherDataModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourlyWeatherData) { data in
                    HourlyWeatherCellView(hourlyWeatherData: data)
                    Spacer().frame(width: 24)
                }
            }.padding(.horizontal, 24)
        }
    }
}

#Preview {
    HourlyWeatherView(hourlyWeatherData: [WeatherDataModel.emptyInit()])
}
