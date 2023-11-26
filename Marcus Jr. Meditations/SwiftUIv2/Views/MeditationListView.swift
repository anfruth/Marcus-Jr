//
//  MeditationListView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationListView: View, MeditationNavigating {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var routingState: RoutingState
    @StateObject var viewModel: MeditationListViewModel
    
    @Binding var isShowingMeditationList: Bool
    
    var body: some View {
        VStack {
            if let meditationVM = viewModel.meditationVM {
                let meditationView = MeditationView(viewModel: meditationVM, isShowingMeditationList: $isShowingMeditationList)
                NavigationLink(destination: meditationView, isActive: $viewModel.meditationSelected) { EmptyView() }
            }
            
            if viewModel.meditationSummaries.count == 1 {
                MeditationPreviewText(viewModel: viewModel)
            } else {
                InnerMeditationListView(viewModel: viewModel, animation: .linear(duration: 1.0))
            }
        }
        .navigationTitle(viewModel.emotionText)
        .navigationBarItems(leading: Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(uiColor: .label))
        }), trailing: Button(action: { viewModel.deleteAllDates() }, label: {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(!viewModel.anyMeditationComplete() || viewModel.meditationSummaries.count == 1  ? Color(uiColor: .systemGray) : .primary)
        })
            .disabled(!viewModel.anyMeditationComplete() || viewModel.meditationSummaries.count == 1)
        )
        .navigationBarBackButtonHidden()
        .alert(viewModel.alertInfo?.title ?? "", isPresented: $viewModel.showAlert, actions: {
            let acceptOption = viewModel.alertInfo?.acceptActionOption ?? ""
            Button(acceptOption, role: .destructive) {
                _ = viewModel.alertInfo?.acceptAction?()
            }
        }, message: {
            Text(viewModel.alertInfo?.message ?? "")
        })
        .onAppear {
            handleRoutingOnAppear()
            viewModel.updateMeditationSummaries()
        }
        .onChange(of: routingState.isActive) { isActive in
            handleRoutingOnChange()
        }
    }
    
    func route(using meditationId: String, through emotionText: String) {
        
        if !viewModel.isRoutedEmotionCorrect(from: emotionText) {
            isShowingMeditationList = false
        } else {
            DispatchQueue.main.async {
                viewModel.selectMeditation(from: meditationId)
            }
        }
        
    }
}

struct MeditationListView_Previews: PreviewProvider {
    
    static var emotion: EmotionDescription {
        let emotionDesc = EmotionDescription(context: DataController.sharedInstance.container.viewContext)
        emotionDesc.emotion = "Loss"
        return emotionDesc
    }
    static var previews: some View {
        NavigationView {
            MeditationListView(viewModel: MeditationListViewModel(emotionDescription: Self.emotion,
                                                                  notificationManager: LocalNotificationManager()),
                               isShowingMeditationList: .constant(true))
            .environmentObject(NotificationsReceiver.sharedInstance.routingState)
        }
        .navigationViewStyle(.stack)
    }
}
