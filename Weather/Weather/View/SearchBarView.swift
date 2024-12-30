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
        
        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for a city or country", text: $locationInput)
                        .onChange(of: locationInput) { newValue in
                            // Split the input by comma, if present
                            let components = newValue.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
                            
                            // Handle cases based on how many components are in the input
                            if components.count == 1 {
                                // Only city entered
                                Task {
                                    await viewModel.fetchGeoData(city: components[0], state: "", country: "")
                                }
                            } else if components.count == 2 {
                                // City and country entered (state is optional)
                                Task {
                                    await viewModel.fetchGeoData(city: components[0], state: "", country: components[1])
                                }
                            } else if components.count == 3 {
                                // City, state, and country entered
                                Task {
                                    await viewModel.fetchGeoData(city: components[0], state: components[1], country: components[2])
                                }
                            }
                        }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding()
            }
        }
    }

    #Preview {
        SearchBarView()
    }
