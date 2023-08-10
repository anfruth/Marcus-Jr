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
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var routingState: RoutingState
    
    @Binding var isShowingMeditationList: Bool

    var body: some View {
        VStack {
            ScrollView {
                Text("Quotation:")
                    .bold()
                Text(viewModel.quotation)
                    .padding()
                
                if viewModel.commentaryAvailable {
                    Text("Commentary:")
                        .bold()
                    Text(viewModel.commentary)
                        .padding()
                }
                
                if viewModel.actionAvailable {
                    Text("Action:")
                        .bold()
                    Text(viewModel.action)
                        .padding()
                }
            }
            .padding([.top, .bottom])
            .navigationTitle(viewModel.enchiridionChapter)
            .navigationBarItems(leading: Button(action: { dismiss() }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(uiColor: .label))
            }))
            .navigationBarBackButtonHidden()
            
            NavigationLink(destination: viewModel.meditationDatesView(isShowingMeditationList: $isShowingMeditationList), isActive: $viewModel.dateSettingAllowed) { EmptyView() }
                .isDetailLink(false)
            
            MarcusCommonButton(title: "Set Meditation Times") {
                if !viewModel.dateSettingAllowed {
                    Task { @MainActor in
                        await viewModel.getNotificationPermissionIfNeeded()
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
            .padding([.bottom])
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
    }
    
    func route(using meditationId: String, through emotionText: String) {
        if !viewModel.isRoutedToMeditation(from: meditationId) {
            isShowingMeditationList = false
        } else if viewModel.isRoutedToMeditation(from: meditationId) {
            // TODO: Refactor this
            NotificationsReceiver.sharedInstance.routingState.isActive = false
            NotificationsReceiver.sharedInstance.routingState.meditationId = nil
            NotificationsReceiver.sharedInstance.routingState.emotionText = nil
            UINavigationBar.setAnimationsEnabled(true)
        }
    }
    
    private func openSettingsUrl() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//struct MeditationView_Previews: PreviewProvider {
//    
//    static var meditation: Meditation {
//        let meditation = Meditation(context: DataController.sharedInstance.container.viewContext)
//        meditation.localizedId = "01Be_unattached"
//        meditation.visitedAfterFinalTime = false
//        return meditation
//    }
//    
//    static var previews: some View {
//        NavigationView {
//            MeditationView(viewModel: MeditationViewModel(meditation: meditation, emotionDescription: EmotionDescription(context: DataController.sharedInstance.container.viewContext)))
//        }
//    }
//}
