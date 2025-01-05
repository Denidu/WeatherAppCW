//
//  MapView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-04.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0), // Default center
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            if let location = locationManager.currentLocation {
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .edgesIgnoringSafeArea(.all) // Make the map cover the entire screen
                    .onAppear {
                        // Update the region to center on the user's current location
                        region.center = CLLocationCoordinate2D(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                    }
            } else if let error = locationManager.locationError {
                VStack {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the error message
                .background(Color.white.edgesIgnoringSafeArea(.all)) // Full-screen background
            } else {
                VStack {
                    Text("Fetching location...")
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the loading message
                .background(Color.white.edgesIgnoringSafeArea(.all)) // Full-screen background
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    MapView()
}
