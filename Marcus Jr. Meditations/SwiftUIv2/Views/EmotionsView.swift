//
//  EmotionsView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/7/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionsView: View, MeditationNavigating {

    // TODO: Refactor out knowledge of emotion model from View -> VM
    
    @StateObject var viewModel: EmotionsViewModel
    @EnvironmentObject var routingState: RoutingState
    
    let animation = Animation.easeOut(duration: 0.8)
    private let navTitle = "Choose Emotion"

    var body: some View {
        
        GeometryReader { proxy in

            ScrollView(viewModel.emotionsInGrid.count != 1 ? [.vertical] : []) {
                
                if let selectedEmotion = viewModel.selectedEmotion {
                    let meditationListViewModel = MeditationListViewModel(emotionDescription: selectedEmotion,
                                                                        notificationManager: LocalNotificationManager())
                    let destination = MeditationListView(viewModel: meditationListViewModel, isShowingMeditationList: $viewModel.isShowingMeditationList)
                    NavigationLink(destination: destination, isActive: $viewModel.isShowingMeditationList) { EmptyView() }
                        .isDetailLink(false)
                    
                }
                
                EmotionsLazyGrid(viewModel: viewModel, animation: animation, proxyHeight: proxy.size.height)
            }
        }
        .navigationTitle("Choose Emotion")
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: [.leading, .trailing, .bottom])
        .onAppear {
            handleRoutingOnAppear()
            viewModel.emotionsInGrid = viewModel.sortedEmotionDescriptions
        }
        .onChange(of: routingState.isActive) { isActive in
            handleRoutingOnChange()
        }
    }

    func route(using meditationId: String, through emotionText: String) {        
        viewModel.selectEmotion(from: emotionText)
    }

}

struct EmotionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                EmotionsView(viewModel: EmotionsViewModel())
                    .environmentObject(NotificationsReceiver.sharedInstance.routingState)
            }
            .navigationViewStyle(.stack)
            
            NavigationView {
                EmotionsView(viewModel: EmotionsViewModel())
                    .previewInterfaceOrientation(.landscapeLeft)
                    .environmentObject(NotificationsReceiver.sharedInstance.routingState)
            }
            .navigationViewStyle(.stack)
        }
    }
}
