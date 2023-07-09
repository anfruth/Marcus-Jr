//
//  EmotionsLazyGrid.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/24/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionsLazyGrid: View {
    
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var viewModel: EmotionsViewModel
    
    let animation: Animation
    let proxyHeight: Double
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: viewModel.emotionsInGrid.count != 1 ? 2 : 1), spacing: 0) {
            if viewModel.emotionsInGrid.count != 1 {
                ForEach(viewModel.emotionsInGrid.indices, id: \.self) { index in
                    Button {
                        emotionButtonAction(from: index)()
                    } label: {
                        EmotionGridCellView(emotionDescription: viewModel.emotionsInGrid[index], minHeight: 175, font: .title2)
                    }
                    .disabled(viewModel.emotionsInGrid.count == 1)
                }
            } else if let selectedEmotion = viewModel.selectedEmotion {
                EmotionGridCellView(emotionDescription: selectedEmotion, minHeight: proxyHeight, font: .largeTitle)
            }
        }
    }
    
    private func emotionButtonAction(from index: Int) -> () -> Void {
        return {
            if viewModel.emotionsInGrid.count != 1 {
                withAnimation(animation) {
                    viewModel.selectedEmotion = EmotionFactory.sharedInstance.getEmotionDescription(from: Emotion.allCases[index]) // TODO: fix this, take out of view
                    if let selectedEmotion = viewModel.selectedEmotion {
                        viewModel.emotionsInGrid = [selectedEmotion]
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    viewModel.isShowingMeditationList = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.emotionsInGrid = viewModel.sortedEmotionDescriptions
                    }
                }
            }
        }
    }
}

struct EmotionsLazyGrid_Previews: PreviewProvider {
    static var previews: some View {
        EmotionsLazyGrid(viewModel: EmotionsViewModel(), animation: Animation.easeOut(duration: 0.8), proxyHeight: 900)
    }
}
