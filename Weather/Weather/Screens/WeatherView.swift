//
//  WeatherView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-04.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer().frame(height: 40)
                    if let weatherData = viewModel.weatherDataModel {
                        VStack(alignment: .center) {
                            Text(viewModel.currentLocationName ?? "Unknown Location")
                                .font(.system(size: 34, weight: .medium))
                            
                            Text("\(Int(weatherData.current.temp))°")
                                .font(.system(size: 94, weight: .thin))
                            
                            Text(weatherData.current.weather.first?.description.capitalized ?? "")
                                .font(.title3)
                            
                            Text("H:\(Int(weatherData.daily[0].temp.max))° L:\(Int(weatherData.daily[0].temp.min))°")
                                .font(.title3)
                            
                            // Hourly forecast
                            VStack(alignment: .leading, spacing: 20)  {
                                Text("HOURLY FORECAST")
                                    .font(.caption)
                                    .padding(.top)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(weatherData.hourly.prefix(10), id: \.dt) { hour in
                                            VStack {
                                                let formattedDate = DateFormatterUtils.formattedDate12Hour(from: TimeInterval(hour.dt))
                                                Text(formattedDate)
                                                
                                                let iconName = hour.weather.first?.icon ?? "default-icon"
                                                let iconUrl = "http://openweathermap.org/img/wn/\(iconName)@2x.png"
                                                
                                                AsyncImage(url: URL(string: iconUrl)) { image in
                                                    image.resizable()
                                                        .scaledToFit()
                                                        .frame(width: 50, height: 50)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                
                                                Text("\(Int(hour.temp))°")
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding()
                        }
                        
                        // 10-day forecast
                        VStack(alignment: .leading, spacing: 10) {
                            Text("10-DAY FORECAST")
                                .font(.caption)
                                .padding(.top)
                            
                            ForEach(weatherData.daily.prefix(5), id: \.dt) { day in
                                HStack {
                                    let formattedDate = DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt))
                                    Text(formattedDate)
                                    Spacer()
                                    
                                    let iconName = day.weather.first?.icon ?? "default-icon"
                                    let iconUrl = "http://openweathermap.org/img/wn/\(iconName)@2x.png"
                                    
                                    AsyncImage(url: URL(string: iconUrl)) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    Text("\(Int(day.temp.min))°")
                                        .frame(width: 30, alignment: .trailing)
                                    TempBarView(min: day.temp.min, max: day.temp.max)
                                        .frame(width: 100)
                                    Text("\(Int(day.temp.max))°")
                                        .frame(width: 30, alignment: .trailing)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        
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
                .onAppear {
                    print("Requesting location from MainView...")
                    viewModel.fetchCurrentLocationWeather()
                }
            }

        }
    }
}


#Preview {
    WeatherView()
}
