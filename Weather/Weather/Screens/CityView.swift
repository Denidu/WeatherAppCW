//
//  CityView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-02.
//

import SwiftUI

struct CityView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var favoriteCities: [GeoDataModel]
    @StateObject var viewModel: WeatherViewModel

    var body: some View {
        VStack(spacing: 16) {
            if let geoData = viewModel.geoDataModel {
                Text(geoData.name)
                    .font(.largeTitle)
                    .bold()

                if let weatherData = viewModel.weatherDataModel {
                    Text(String(format: "%.0f°", weatherData.current.temp))
                        .font(.system(size: 68))
                        .bold()

                    if let weatherDescription = weatherData.current.weather.first?.weatherDescription.rawValue {
                        Text(weatherDescription.capitalized)
                            .font(.title)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text(String(format: "H: %.0f°", weatherData.daily.first?.temp.max ?? 0))
                            .font(.headline)
                        Text(String(format: "L: %.0f°", weatherData.daily.first?.temp.min ?? 0))
                            .font(.headline)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationBarItems(
            trailing: Button("Add") {
                addCityToFavorites()
            }
        )
        .onAppear {
            if let geoData = viewModel.geoDataModel {
                Task {
                    await viewModel.fetchWeatherData(lat: geoData.lat, lon: geoData.lon)
                }
            }
        }
    }

    private func addCityToFavorites() {
        favoriteCities.append(viewModel.geoDataModel ?? GeoDataModel.emptyInit()) // Add the city to the favorites list
        presentationMode.wrappedValue.dismiss() // Dismiss the current view after adding
    }
}

#Preview {
    CityView(favoriteCities: .constant([]), viewModel: WeatherViewModel())
}

