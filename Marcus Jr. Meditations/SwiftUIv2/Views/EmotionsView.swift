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
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var routingState: RoutingState
    
    let animation = Animation.easeOut(duration: 0.8)
    private let navTitle = "Choose Emotion"

    var body: some View {
        
        GeometryReader { proxy in

            ScrollView(viewModel.emotionsInGrid.count != 1 ? [.vertical] : []) {
                
                if let selectedEmotion = viewModel.selectedEmotion {
                    let meditationListViewModel = MeditationListViewModel(emotionDescription: selectedEmotion,
                                                                          moc: moc,
                                                                        notificationManager: LocalNotificationManager())
                    let destination = MeditationListView(viewModel: meditationListViewModel, isShowingMeditationList: $viewModel.isShowingMeditationList)
                    NavigationLink(destination: destination, isActive: $viewModel.isShowingMeditationList) { EmptyView() }
                        .isDetailLink(false)
                    
                }
                
                EmotionsLazyGrid(viewModel: viewModel, animation: animation, proxyHeight: proxy.size.height)
            }
        }
        .navigationTitle(viewModel.emotionsInGrid.count != 1 ? "Choose Emotion" : "")
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(edges: viewModel.emotionsInGrid.count != 1 ? [.leading, .trailing, .bottom] : [.all])
        .onAppear {
            if routingState.isActive {
                if let meditationId = routingState.meditationId, let emotionText = routingState.emotionText {
                    route(using: meditationId, through: emotionText)
                }
            }
        }
        .onChange(of: routingState.isActive) { isActive in
            if let meditationId = routingState.meditationId, let emotionText = routingState.emotionText, isActive {
                route(using: meditationId, through: emotionText)
            }
        }
    }
    
    
    // TODO: Refactor out knowledge of emotion model from View -> VM
    func route(using meditationId: String, through emotionText: String) {
        // something like viewModel.setSelectedEmotion(from emotionText: String)
        guard let emotion = Emotion(rawValue: emotionText) else {
            // TODO: Refactor this
            NotificationsReceiver.sharedInstance.routingState.isActive = false
            NotificationsReceiver.sharedInstance.routingState.meditationId = nil
            NotificationsReceiver.sharedInstance.routingState.emotionText = nil
            UINavigationBar.setAnimationsEnabled(true)
            return
        }
        
        DispatchQueue.main.async {
            viewModel.selectedEmotion = EmotionFactory.sharedInstance.getEmotionDescription(from: emotion)
            viewModel.isShowingMeditationList = true
        }
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
