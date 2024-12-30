//
//  CurrentLocAndTemHeaderView.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import SwiftUI

struct CurrentLocAndTemHeaderView: View {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var weatherViewModel = WeatherViewModel()
    let weatherData: WeatherDataModel
        
        var body: some View {
            VStack {
            if let locationName = locationManager.locationName,
               let location = locationManager.currentLocation {
                    Text("\(locationName)")
                        .font(.system(size: 30))
                        .bold()
                    }
                
                Text(String(format: "%.0f°", weatherData.current.temp))
                    .font(.system(size: 68))
                    .bold()
                
                Text("\(String(describing: weatherData.current.weather.first?.weatherDescription))")
                    .font(.system(size: 30))
                    .bold()
                
                    
                HStack {
                    Text(String(format: "H:%.0f°", weatherData.daily.first?.temp.min ?? 0))
                        .font(.system(size: 20))
                        
                    Text(String(format: "L:%.0f°", weatherData.daily.first?.temp.max ?? 0))
                        .font(.system(size: 20))
                }
        }
        .padding()
        .onAppear {
            locationManager.requestLocation()
        }
    }
}


#Preview {
    CurrentLocAndTemHeaderView(weatherData: WeatherDataModel.emptyInit())
    
}

