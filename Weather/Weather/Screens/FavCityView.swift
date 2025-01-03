//
//  FavCityView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-02.
//

import SwiftUI

struct FavCityView: View {
    @AppStorage("favoriteCities") private var favoriteCities: String = ""
    @State private var searchQuery: String = ""

    private var favoriteCitiesArray: [String] {
        favoriteCities.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }
    }

    var body: some View {
        NavigationView {
            VStack {
                
                SearchBarView()
                
                if favoriteCitiesArray.isEmpty {
                    Text("No favorite cities.")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        ForEach(favoriteCitiesArray, id: \.self) { city in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(city)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding()
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding(.horizontal)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .navigationBarTitle("Weather")
        }
    }
}

#Preview {
    FavCityView()
}
