//
//  MainView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @AppStorage("locationInput") private var locationInput: String = ""

        var body: some View {
            NavigationView {
                VStack {
                    
                    SearchBarView()

                    
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
                        Text("Enter a city name to see the weather.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .navigationTitle("Weather App")
                .onAppear {
                    if locationInput.isEmpty {
                        Task {
                            await viewModel.fetchGeoData(city: "London", state: "", country: "")
                        }
                    }
                }
            }
        }
    }

    #Preview {
        MainView()
    }
