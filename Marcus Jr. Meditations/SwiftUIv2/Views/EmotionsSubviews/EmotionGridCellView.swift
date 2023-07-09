//
//  EmotionsGridView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/24/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionGridCellView: View {
    
    let emotionDescription: EmotionDescription
    let minHeight: Double
    let font: Font
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(getFillColor(from: emotionDescription))
                .frame(minHeight: minHeight)
            Text(emotionDescription.emotion ?? "")
                .font(font)
                .foregroundColor(.white)
        }
    }
    
    private func getFillColor(from emotionDescription: EmotionDescription) -> Color {
        let emotion = Emotion(rawValue: emotionDescription.emotion ?? "") ?? .anger
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

//struct EmotionsGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            EmotionGridCellView(emotionDescription: .anxiety, minHeight: 175, font: .title2)
//        }
//    }
//}
