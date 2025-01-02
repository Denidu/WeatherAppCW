//
//  MainView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let weatherData = viewModel.weatherDataModel {
                    ScrollView {
                        VStack(spacing: 16) {
                            HourlyWeatherView(hourlyWeatherData: [weatherData])
                            Rectangle().frame(height: 1).foregroundColor(.gray)
                            DailyWeatherView(weatherData: [weatherData])
                        }
                        .padding()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("Fetching weather for your current location...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Weather App")
            .onAppear {
                viewModel.fetchCurrentLocationWeather()
            }
        }
    }
}

#Preview {
    MainView()
}
