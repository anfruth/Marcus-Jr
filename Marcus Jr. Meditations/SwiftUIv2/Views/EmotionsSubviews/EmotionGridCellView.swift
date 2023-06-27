//
//  EmotionsGridView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/24/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionGridCellView: View {
    
    let emotion: Emotion
    let minHeight: Double
    let font: Font
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(getFillColor(from: emotion))
                .frame(minHeight: minHeight)
            Text(emotion.rawValue)
                .font(font)
                .foregroundColor(.white)
        }
    }
    
    private func getFillColor(from emotion: Emotion) -> Color {
        switch emotion {
        case .loss, .anxiety, .discipline:
            return Color(red:0.30, green:0.39, blue:0.55)
        case .anger, .envy, .empathy:
            return Color(red:0.16, green:0.21, blue:0.33)
        case .sadness, .persevere, .courage:
            return Color(red:0.12, green:0.12, blue:0.15)
        }
    }
}

struct EmotionsGridView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmotionGridCellView(emotion: .anxiety, minHeight: 175, font: .title2)
        }
    }
}
