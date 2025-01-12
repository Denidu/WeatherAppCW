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
    @State private var searchText: String = ""
    @State private var annotations: [MKPointAnnotation] = []
    
    var favoriteCitiesArr: [String] {
        favoriteCities.split(separator: ",").map { String($0) }.filter { !$0.isEmpty }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if let location = locationManager.existingLocation {
                    Map(coordinateRegion: $area, annotationItems: annotationItems()) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            VStack {
                                Image(systemName: annotation.isCurrentLocation ? "location.circle.fill" : "mappin.and.ellipse.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(annotation.isCurrentLocation ? .blue : .blue)
                                if !annotation.isCurrentLocation {
                                    Text(annotation.id)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                            }
                            .onTapGesture {
                                if !annotation.isCurrentLocation {
                                    Task {
                                        await weatherViewModel.fetchWeatherForCity(city: annotation.id)
                                        selectedCity = annotation.id
                                    }
                                }
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        loadFavoriteCityCoordinates()
                        area.center = location.coordinate
                        isLoading = false
                    }
                }
                
                VStack {
                    MapSearchBarView(searchText: $searchText, onSearch: searchPlaces)
                        .padding(.top)
                        .background(Color.white.opacity(0.7))
                    Spacer()
                }
                if isLoading {
                    ProgressView("Fetching location...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let error = locationManager.locationError {
                    VStack {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: zoomIn) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 10)
                            Button(action: zoomOut) {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    }
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
    
    func searchPlaces() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "tourist attractions in \(searchText)"
        request.region = area
        request.resultTypes = [.pointOfInterest]
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error searching for places: \(error.localizedDescription)")
                return
            }
            
            if let response = response {
                let topResults = response.mapItems.prefix(5)
                annotations = topResults.compactMap { item in
                    guard let name = item.name else { return nil }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = name
                    return annotation
                }
                adjustMapRegion()
            }
        }
    }
    
    private func annotationItems() -> [CityAnnotation] {
        var allAnnotations = favoriteCityCoordinates.map { CityAnnotation(id: $0.key, coordinate: $0.value) }
        if let location = locationManager.existingLocation {
            allAnnotations.append(CityAnnotation(id: "Current Location", coordinate: location.coordinate, isCurrentLocation: true))
        }
        allAnnotations.append(contentsOf: annotations.map {
            CityAnnotation(id: $0.title ?? "Unknown", coordinate: $0.coordinate)
        })
        return allAnnotations
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
    
    private func adjustMapRegion() {
        var minLat = annotations.map { $0.coordinate.latitude }.min() ?? area.center.latitude
        var maxLat = annotations.map { $0.coordinate.latitude }.max() ?? area.center.latitude
        var minLon = annotations.map { $0.coordinate.longitude }.min() ?? area.center.longitude
        var maxLon = annotations.map { $0.coordinate.longitude }.max() ?? area.center.longitude
        
        let padding: CLLocationDegrees = 0.05
        minLat -= padding
        maxLat += padding
        minLon -= padding
        maxLon += padding
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        
        area.center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
        area.span = MKCoordinateSpan(
            latitudeDelta: maxLat - minLat,
            longitudeDelta: maxLon - minLon
        )
    }
}

struct CityAnnotation: Identifiable {
    var id: String
    var coordinate: CLLocationCoordinate2D
    var isCurrentLocation: Bool = false
}

#Preview {
    MapView()
}
