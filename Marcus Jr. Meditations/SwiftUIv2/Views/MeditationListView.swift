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
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var routingState: RoutingState
    @StateObject var viewModel: MeditationListViewModel
    
    @Binding var isShowingMeditationList: Bool
    
    let animation = Animation.linear(duration: 1.0)
    
    var body: some View {
        VStack {
            if let meditationVM = viewModel.meditationVM {
                let meditationView = MeditationView(viewModel: meditationVM, isShowingMeditationList: $isShowingMeditationList)
                NavigationLink(destination: meditationView, isActive: $viewModel.meditationSelected) { EmptyView() }
                    .isDetailLink(false)
            }
            
            if viewModel.meditationSummaries.count == 1 {
                Text(viewModel.meditationSummaries[0].meditationID)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List(viewModel.meditationSummaries, id: \.meditationID) { summary in
                    VStack {
                        Spacer()
                        Button {
                            withAnimation(animation) {
                                viewModel.showSingleSelectedMeditationPreview(from: summary.index)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                viewModel.selectMeditation(from: summary.index)
                            }
                        } label: {
                            ZStack {
                                Rectangle()
                                    .cornerRadius(8)
                                    .foregroundColor(Color(.secondarySystemBackground))
                                    .shadow(radius: 5, x: 2, y: 3)
                                Text(summary.meditationID)
                                    .foregroundColor(summary.isComplete ? Color(uiColor: .systemGray) :  Color(uiColor: .label))
                                    .strikethrough(summary.isComplete, color: colorScheme == .light ? .black : .white)
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
                                                                  moc: DataController.sharedInstance.container.viewContext,
                                                                  notificationManager: LocalNotificationManager()),
                               isShowingMeditationList: .constant(true))
            .environmentObject(NotificationsReceiver.sharedInstance.routingState)
        }
        .navigationViewStyle(.stack)
    }
}
