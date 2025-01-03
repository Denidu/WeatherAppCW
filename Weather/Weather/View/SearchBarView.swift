//
//  SearchBarView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct SearchBarView: View {
    @AppStorage("locationInput") private var locationInput: String = ""
    @StateObject private var viewModel = WeatherViewModel()
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var isNavigating: Bool = false // State to control navigation

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for a city or country", text: $locationInput)
                    .onChange(of: locationInput) { newValue in
                        debounceWorkItem?.cancel()

                        let newWorkItem = DispatchWorkItem {
                            let components = newValue.split(separator: ",").map {
                                $0.trimmingCharacters(in: .whitespaces)
                            }

                            Task {
                                if components.count == 1 {
                                    try await viewModel.fetchGeoData(city: components[0], state: "", country: "")
                                } else if components.count == 2 {
                                    try await viewModel.fetchGeoData(city: components[0], state: "", country: components[1])
                                } else if components.count == 3 {
                                    try await viewModel.fetchGeoData(city: components[0], state: components[1], country: components[2])
                                }
                                // Enable navigation to CityView when data is fetched
                                isNavigating = viewModel.weatherDataModel != nil
                            }
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: newWorkItem)
                        debounceWorkItem = newWorkItem
                    }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .padding()

            // NavigationLink to CityView - only activate when weatherData is available
            NavigationLink(
                destination: CityView(weatherData: viewModel.weatherDataModel),
                isActive: $isNavigating
            ) {
                EmptyView() // No visible content, only triggers navigation
            }
        }
    }
}

#Preview {
    SearchBarView()
}
