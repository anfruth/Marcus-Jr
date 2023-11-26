//
//  MeditationView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/26/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI
import UIKit

struct MeditationView: View, MeditationNavigating {

    @StateObject var viewModel: MeditationViewModel
    @EnvironmentObject var routingState: RoutingState
    
    @Binding var isShowingMeditationList: Bool

    var body: some View {
        VStack {
            MeditationContentContainer(viewModel: viewModel)
            
            NavigationLink(destination: viewModel.meditationDatesView(isShowingMeditationList: $isShowingMeditationList), isActive: $viewModel.dateSettingAllowed) { EmptyView() }
                .isDetailLink(false)
            
            MarcusCommonButton(title: "Set Meditation Times") {
                if !viewModel.dateSettingAllowed {
                    Task {
                        await viewModel.getNotificationPermissionIfNeeded()
                    }
                }
            }
        }
        .alert(viewModel.alertInfo?.title ?? "", isPresented: $viewModel.showAlert, actions: {
            Button(viewModel.alertInfo?.acceptActionOption ?? "") {
                if viewModel.alertInfo?.acceptAction?() == true {
                    openSettingsUrl()
                }
            }
            Button(viewModel.alertInfo?.declineActionOption ?? "") {
                viewModel.alertInfo?.declineAction?()
            }
        }, message: {
            Text(viewModel.alertInfo?.message ?? "")
        })
        .onAppear {
            handleRoutingOnAppear()
            viewModel.markAsCompleteIfComplete(timeVisited: Date.now)
        }
        .onChange(of: routingState.isActive) { isActive in
            handleRoutingOnChange()
        }
    }
    
    func route(using meditationId: String, through emotionText: String) {
        if !viewModel.isRoutedToMeditation(from: meditationId) {
            isShowingMeditationList = false
        } else if viewModel.isRoutedToMeditation(from: meditationId) {
            viewModel.completeRouting()
        }
    }
    
    private func openSettingsUrl() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct MeditationView_Previews: PreviewProvider {
    
    static var meditation: Meditation {
        let meditation = Meditation(context: DataController.sharedInstance.container.viewContext)
        meditation.localizedId = "01Be_unattached"
        meditation.visitedAfterFinalTime = false
        return meditation
    }
    
    static var secondMeditation: Meditation {
        let meditation = Meditation(context: DataController.sharedInstance.container.viewContext)
        meditation.localizedId = "02Desire_things"
        meditation.visitedAfterFinalTime = false
        return meditation
    }
    
    static var previews: some View {
        NavigationView {
            MeditationView(viewModel: MeditationViewModel(meditation: meditation, emotionDescription: EmotionDescription(context: DataController.sharedInstance.container.viewContext)), isShowingMeditationList: .constant(true))
                .environmentObject(NotificationsReceiver.sharedInstance.routingState)
        }
        .navigationViewStyle(.stack)
        
        NavigationView {
            MeditationView(viewModel: MeditationViewModel(meditation: secondMeditation, emotionDescription: EmotionDescription(context: DataController.sharedInstance.container.viewContext)), isShowingMeditationList: .constant(true))
                .environmentObject(NotificationsReceiver.sharedInstance.routingState)
        }
        .navigationViewStyle(.stack)
    }
}
