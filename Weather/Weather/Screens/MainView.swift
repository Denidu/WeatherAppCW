//
//  MainView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 1  

    var body: some View {
        VStack {
            ZStack {
                if selectedTab == 0 {
                    MapView()
                } else if selectedTab == 1 {
                    WeatherView()
                } else if selectedTab == 2 {
                    FavCityView()
                }
            }

            HStack {
                Spacer()

                Button(action: {
                    selectedTab = 0
                }) {
                    Image(systemName: "map")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 0 ? .blue : .gray)
                        .padding()
                }
                
                Spacer()

                Button(action: {
                    selectedTab = 1
                }) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12)) // Smaller icon size for Weather tab
                        .foregroundColor(selectedTab == 1 ? .blue : .gray)
                        .padding()
                }
                
                Spacer()

                Button(action: {
                    selectedTab = 2
                }) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == 2 ? .blue : .gray)
                        .padding()
                }
                
                Spacer()
            }
            .frame(height: 60)
            .background(Color.white.shadow(radius: 5))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainView()
}
