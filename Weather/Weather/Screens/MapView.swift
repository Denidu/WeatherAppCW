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
    @ObservedObject var weatherViewModel = WeatherViewModel()
    @AppStorage("favoriteCities") private var favoriteCities: String = ""
    @State private var area = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    )
    @State private var selectedCity: String?
    @State private var favoriteCityCoordinates: [String: CLLocationCoordinate2D] = [:]
    @State private var isLoading: Bool = true

    var favoriteCitiesArr: [String] {
        favoriteCities.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }
    }

    var body: some View {
        NavigationView {
            ZStack {
                if let location = locationManager.existingLocation {
                    Map(coordinateRegion: $area, annotationItems: favoriteCityCoordinates.keys.sorted().map { city in
                        CityAnnotation(id: city, coordinate: favoriteCityCoordinates[city] ?? CLLocationCoordinate2D())
                    }, annotationContent: { cityAnnotation in
                        MapAnnotation(coordinate: cityAnnotation.coordinate) {
                            Button(action: {
                                Task {
                                    await weatherViewModel.fetchWeatherForCity(city: cityAnnotation.id)
                                    selectedCity = cityAnnotation.id
                                }
                            }) {
                                VStack {
                                    Image(systemName: "mappin.and.ellipse.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.red)
                                    Text(cityAnnotation.id)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    })
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        loadFavoriteCityCoordinates()
                        area.center = CLLocationCoordinate2D(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                        isLoading = false
                    }
                } else if let error = locationManager.locationError {
                    VStack {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.edgesIgnoringSafeArea(.all))
                } else {
                    VStack {
                        if isLoading {
                            ProgressView("Fetching location...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else {
                            Text("Location not found.")
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.edgesIgnoringSafeArea(.all))
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                zoomIn()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 10)

                            Button(action: {
                                zoomOut()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                }

                NavigationLink(
                    destination: CityView(cityName: selectedCity ?? "", weatherData: weatherViewModel.weatherDataModel),
                    isActive: Binding(get: { selectedCity != nil }, set: { _ in selectedCity = nil }),
                    label: { EmptyView() }
                )
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }

    private func loadFavoriteCityCoordinates() {
        Task {
            for city in favoriteCitiesArr {
                favoriteCityCoordinates[city] = await fetchCoordinates(for: city)
            }
        }
    }

    private func fetchCoordinates(for city: String) async -> CLLocationCoordinate2D {
        do {
            try await weatherViewModel.fetchGeoData(city: city, state: "", country: "")
            if let geoData = weatherViewModel.geoDataModel {
                return CLLocationCoordinate2D(latitude: geoData.lat, longitude: geoData.lon)
            }
        } catch {
            print("Error fetching coordinates for \(city): \(error)")
        }
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    private func zoomIn() {
        let newSpan = MKCoordinateSpan(
            latitudeDelta: area.span.latitudeDelta / 1.5,
            longitudeDelta: area.span.longitudeDelta / 1.5
        )
        area.span = newSpan
    }

    private func zoomOut() {
        let newSpan = MKCoordinateSpan(
            latitudeDelta: area.span.latitudeDelta * 1.5,
            longitudeDelta: area.span.longitudeDelta * 1.5
        )
        area.span = newSpan
    }
}

struct CityAnnotation: Identifiable {
    var id: String
    var coordinate: CLLocationCoordinate2D
}

#Preview {
    MapView()
}

