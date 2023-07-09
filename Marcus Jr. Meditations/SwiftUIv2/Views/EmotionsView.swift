//
//  EmotionsView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/7/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionsView: View {
    
    // TODO: Refactor out knowledge of emotion model from View -> VM
    
    @StateObject var viewModel: EmotionsViewModel
    @Environment(\.managedObjectContext) var moc
    
    let animation = Animation.easeOut(duration: 0.8)
    private let navTitle = "Choose Emotion"
    
    var body: some View {
        
        GeometryReader { proxy in

            ScrollView(viewModel.emotionsInGrid.count != 1 ? [.vertical] : []) {
                
                if let selectedEmotion = viewModel.selectedEmotion {
                    let meditationListViewModel = MeditationListViewModel(emotionDescription: selectedEmotion, moc: moc)
                    let destination = MeditationListView(viewModel: meditationListViewModel)
                    NavigationLink(destination: destination, isActive: $viewModel.isShowingMeditationList) { EmptyView() }
                }
                
                EmotionsLazyGrid(emotionsInGrid: $viewModel.emotionsInGrid, selectedEmotion: $viewModel.selectedEmotion,
                                 isShowingMeditationList: $viewModel.isShowingMeditationList, animation: animation, proxyHeight: proxy.size.height)
            }
        }
        .navigationTitle(viewModel.emotionsInGrid.count != 1 ? "Choose Emotion" : "")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: viewModel.emotionsInGrid.count != 1 ? [.leading, .trailing, .bottom] : [.all])
    }

}

struct EmotionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EmotionsView(viewModel: EmotionsViewModel())
            }
            
            NavigationView {
                EmotionsView(viewModel: EmotionsViewModel())
                    .previewInterfaceOrientation(.landscapeLeft)
            }
        }
    }
}
