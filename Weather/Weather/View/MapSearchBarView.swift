//
//  TouristAttractionSearchBar.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-10.
//

import SwiftUI

struct TouristAttractionSearchBar: View {
    @Binding var searchText: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search for places...", text: $searchText, onCommit: onSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
            }
            .padding(.trailing)
        }
    }
}

