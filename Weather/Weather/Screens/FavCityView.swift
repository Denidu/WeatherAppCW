//
//  FavCityView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-02.
//

import SwiftUI

struct FavCityView: View {
    @AppStorage("favoriteCities") private var favoriteCities: String = ""
    @State private var searchInputs: String = ""
    @State private var selectedCity: String?

    private var favoriteCitiesArr: [String] {
        favoriteCities.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }
    }

    private func deleteCity(_ city: String) {
        favoriteCities = favoriteCitiesArr.filter { $0 != city }.joined(separator: ",")
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hue: 0.565, saturation: 0.378, brightness: 0.994)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    SearchBarView()
                        .padding(.top)

                    List {
                        if favoriteCitiesArr.isEmpty {
                            Text("No favorite cities.")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding()
                                .background(Color.clear)
                        } else {
                            ForEach(favoriteCitiesArr.filter { city in
                                searchInputs.isEmpty || city.lowercased().contains(searchInputs.lowercased())
                            }, id: \.self) { city in
                                CityCardView(cityName: city)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            deleteCity(city)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .onTapGesture {
                                        selectedCity = city
                                    }
                                    .listRowBackground(Color(hue: 0.565, saturation: 0.378, brightness: 0.994))
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)

                    NavigationLink(
                        destination: CityView(cityName: selectedCity ?? ""),
                        tag: selectedCity ?? "",
                        selection: $selectedCity
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationBarTitle("Weather")
        }
    }
}

struct CityCardView: View {
    let cityName: String
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
           
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 89 / 255, green: 171 / 255, blue: 227 / 255))

            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
            } else if let weatherData = viewModel.weatherDataModel {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(cityName)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(weatherData.current.weather.first?.description.capitalized ?? "")
                            .font(.body)
                        Spacer()
                        Text("H: \(Int(weatherData.daily[0].temp.max))° L: \(Int(weatherData.daily[0].temp.min))°")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Text("\(Int(weatherData.current.temp))°")
                        .font(.system(size: 60, weight: .medium))
                }
                .padding()
            } else {
                Text("Failed to load weather data")
                    .foregroundColor(.white)
            }
        }
        .foregroundColor(.white)
        .frame(width: 350, height: 120)
        .onAppear {
            fetchData()
        }
    }
    
    private func fetchData() {
        Task {
            isLoading = true
            do {
                try await viewModel.fetchGeoData(city: cityName, state: "", country: "")
                isLoading = false
            } catch {
                isLoading = false
                print("Error loading weather data for \(cityName): \(error)")
            }
        }
    }
}
