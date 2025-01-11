//
//  TempBarView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-03.
//

import SwiftUI

struct TempBarView: View {
    var tempMin: Double
    var tempMax: Double
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color(hue: 0.551, saturation: 0.261, brightness: 0.769))
                .frame(width: CGFloat(tempMin / (tempMax + tempMin) * 100))

            Rectangle()
                .fill(Color(hue: 0.064, saturation: 0.974, brightness: 0.96)) 
                .frame(width: CGFloat(tempMax / (tempMax + tempMin) * 100))
        }
        .cornerRadius(5)
        .frame(height: 5)
    }
}

#Preview {
    TempBarView(tempMin: 15, tempMax: 20)
}
