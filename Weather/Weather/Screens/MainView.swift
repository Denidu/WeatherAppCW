//
//  MainView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct MainView: View {
    @State private var activeTab: Int = 1

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if activeTab == 0 {
                    MapView()
                } else if activeTab == 1 {
                    WeatherView()
                } else if activeTab == 2 {
                    FavCityView()
                }
            }
            
            HStack {
                Spacer()
                Button(action: {
                    activeTab = 0
                }) {
                    Image(systemName: "map")
                        .font(.system(size: 24))
                        .foregroundColor(activeTab == 0 ? .blue : .white)
                        .padding()
                }
                Spacer()
                Button(action: {
                    activeTab = 1
                }) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundColor(activeTab == 1 ? .blue : .white)
                        .padding()
                }
                Spacer()
                Button(action: {
                    activeTab = 2
                }) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 24))
                        .foregroundColor(activeTab == 2 ? .blue : .white)
                        .padding()
                }
                Spacer()
            }
            .frame(height: 60)
            .background(Color.blue.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
        }
        .background(Color.blue.opacity(0.3))
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainView()
}
