//
//  GeoModelData.swift
//  Weather
//
//  Created by Denidu Gamage on 2024-12-29.
//

import Foundation

import Foundation

class GeoDataModel: Codable, Identifiable{
    let id = UUID()
    let name: String
    let localNames: [String:String]?
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case localNames = "local_names"
        case lat
        case lon
        case country
        case state
    }
}
