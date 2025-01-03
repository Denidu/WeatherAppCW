//
//  TempBarView.swift
//  Weather
//
//  Created by Denidu Gamage on 2025-01-03.
//

import SwiftUI

struct TempBarView: View {
    var min: Double
    var max: Double
    
    var body: some View {
        HStack(spacing: 0) {
            // Normalize the width calculation to a reasonable range for the screen
            Rectangle()
                .fill(Color.gray) // Blue for the cooler range
                .frame(width: CGFloat(min / (max + min) * 100)) // Normalized width based on the range

            Rectangle()
                .fill(Color.orange) // Red for the warmer range
                .frame(width: CGFloat(max / (max + min) * 100)) // Normalized width based on the range
        }
        .cornerRadius(5)
        .frame(height: 5)
    }
}

#Preview {
    TempBarView(min: 15, max: 20)
}
