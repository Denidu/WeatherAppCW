//
//  FavCityView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-02.
//

//
//  FavCityView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-02.
//

import SwiftUI

struct FavCityView: View {
    @State private var favoriteCities: [GeoDataModel] = [] 
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationView {
            VStack {

                SearchBarView()
                    .padding()

                List(favoriteCities) { city in
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.title2)
                            .bold()
                        Text("\(city.country)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                }
                .listStyle(PlainListStyle())

                NavigationLink("View Weather", destination: CityView(favoriteCities: $favoriteCities, viewModel: viewModel))
                                    .padding()
            }
            .navigationBarTitle("Weather")
        }
    }
}

#Preview {
    FavCityView()
}

