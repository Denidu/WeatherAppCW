//
//  MapSearchBarView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-08.
//

import SwiftUI

struct MapSearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
            
            TextField("Search for places...", text: $searchText, onCommit: onSearch)
                .padding(.leading, 5)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: searchText) { _ in
                    onSearch()
                }
        }
        .padding(.horizontal, 10)
        .frame(height: 50)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(.horizontal, 20)
    }
}
