//
//  EmotionsView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/7/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionsView: View {
    
    @StateObject var viewModel: EmotionsViewModel
    
    let animation = Animation.easeOut(duration: 0.8)
    private let navTitle = "Choose Emotion"
    
    var body: some View {
        
        GeometryReader { proxy in
            NavigationView {
                ScrollView(viewModel.emotionsInGrid.count != 1 ? [.vertical] : []) {
                    
                    if let selectedEmotion = viewModel.selectedEmotion {
                        let meditationListViewModel = MeditationListViewModel(emotion: selectedEmotion,
                                                                meditations: viewModel.meditations(from: selectedEmotion))
                        let destination = MeditationListView(selectedEmotion: $viewModel.selectedEmotion, isShowingMeditationList: $viewModel.isShowingMeditationList, viewModel: meditationListViewModel)
                        
                        NavigationLink(destination: destination, isActive: $viewModel.isShowingMeditationList) { EmptyView() }
                    }
                    
                    EmotionsLazyGrid(emotionsInGrid: $viewModel.emotionsInGrid, selectedEmotion: $viewModel.selectedEmotion,
                                     isShowingMeditationList: $viewModel.isShowingMeditationList, animation: animation, proxyHeight: proxy.size.height)
                }
                .navigationTitle(viewModel.emotionsInGrid.count != 1 ? "Choose Emotion" : "")
                .ignoresSafeArea(edges: viewModel.emotionsInGrid.count != 1 ? [.leading, .trailing, .bottom] : [.all])
            }
            .navigationBarBackButtonHidden(true)
        }
        .ignoresSafeArea()
    }

}

struct EmotionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmotionsView(viewModel: EmotionsViewModel())
            EmotionsView(viewModel: EmotionsViewModel())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
