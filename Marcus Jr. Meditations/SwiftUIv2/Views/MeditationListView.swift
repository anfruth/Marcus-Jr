//
//  MeditationListView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationListView: View, MeditationNavigating {

    // TODO: Refactor out knowledge of emotion model from View -> VM
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var routingState: RoutingState
    @StateObject var viewModel: MeditationListViewModel
    
    @Binding var isShowingMeditationList: Bool
    
    var body: some View {
        VStack {
            if let meditationVM = viewModel.meditationVM {
                let meditationView = MeditationView(viewModel: meditationVM, isShowingMeditationList: $isShowingMeditationList)
                NavigationLink(destination: meditationView, isActive: $viewModel.meditationSelected) { EmptyView() }
                    .isDetailLink(false)
            }
            
            List(viewModel.meditationSummaries, id: \.self.0) { summary in
                VStack {
                    Spacer()
                    Button {
                        viewModel.selectMeditation(from: summary.1)
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(8)
                                .foregroundColor(Color(.secondarySystemBackground))
                                .shadow(radius: 5, x: 2, y: 3)
                            Text(summary.0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.top, .bottom], 10)
                                .padding([.leading, .trailing], 20)
                        }
                        Spacer(minLength: 5)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)

        }
        .navigationTitle(viewModel.emotionText)
        .navigationBarItems(leading: Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(uiColor: .label))
        }))
        .navigationBarBackButtonHidden()
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

//struct MeditationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MeditationListView(viewModel: MeditationListViewModel(emotion: .loss, meditations:
//                                                                                                                                                    [Meditation(id: "00What_is"),
//                                                                                                                                                     Meditation(id: "01Be_unattached"),
//                                                                                                                                                     Meditation(id: "08Seek the")]))
//        }
//    }
//}
