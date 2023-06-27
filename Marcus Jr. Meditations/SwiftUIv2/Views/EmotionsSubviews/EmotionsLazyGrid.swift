//
//  EmotionsLazyGrid.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/24/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionsLazyGrid: View {
    
    @Binding var emotionsInGrid: [Emotion]
    @Binding var selectedEmotion: Emotion?
    @Binding var isShowingMeditationList: Bool
    
    let animation: Animation
    let proxyHeight: Double
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: emotionsInGrid.count != 1 ? 2 : 1), spacing: 0) {
            if emotionsInGrid.count != 1 {
                ForEach(emotionsInGrid.indices, id: \.self) { index in
                    Button {
                        emotionButtonAction(from: index)()
                    } label: {
                        EmotionGridCellView(emotion: emotionsInGrid[index], minHeight: 175, font: .title2)
                    }
                    .disabled(emotionsInGrid.count == 1)
                }
            } else {
                EmotionGridCellView(emotion: selectedEmotion ?? .anxiety, minHeight: proxyHeight, font: .largeTitle)
            }
        }
    }
    
    private func emotionButtonAction(from index: Int) -> () -> Void {
        return {
            if emotionsInGrid.count != 1 {
                withAnimation(animation) {
                    selectedEmotion = Emotion.allCases[index]
                    emotionsInGrid = [selectedEmotion ?? .anger]
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    isShowingMeditationList = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        emotionsInGrid = Emotion.allCases
                    }
                }
            }
        }
    }
}

struct EmotionsLazyGrid_Previews: PreviewProvider {
    static var previews: some View {
        EmotionsLazyGrid(emotionsInGrid: .constant(Emotion.allCases), selectedEmotion: .constant(nil),
                         isShowingMeditationList: .constant(false), animation: Animation.easeOut(duration: 0.8), proxyHeight: 900)
    }
}
