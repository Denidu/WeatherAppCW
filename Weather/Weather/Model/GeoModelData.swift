//
//  GeoModelData.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import Foundation

import Foundation

class GeoDataModel: Codable, Identifiable{
    let name: String
    let localNames: [String:String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat
        case lon
        case country
        case state
    }
    init(name: String, localNames: [String: String]?, lat: Double, lon: Double, country: String, state: String?) {
            self.name = name
            self.localNames = localNames ?? [:] 
            self.lat = lat
            self.lon = lon
            self.country = country
            self.state = state ?? "Unknown"
        }
    
    static func emptyInit() -> GeoDataModel {
            return GeoDataModel(
                name: "",
                localNames: [:],
                lat: 0.0,
                lon: 0.0,
                country: "",
                state: nil
            )
        }
}
