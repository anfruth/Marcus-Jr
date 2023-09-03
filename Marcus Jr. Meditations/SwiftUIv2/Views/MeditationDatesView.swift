//
//  MeditationDatesView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/1/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationDatesView: View, MeditationNavigating {
    
    @StateObject var viewModel: MeditationDatesViewModel
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var routingState: RoutingState
    
    @Binding var isShowingMeditationList: Bool
    
    var body: some View {
        VStack {
            DatePicker("Choose Time:", selection: $viewModel.selectedDate, in: (viewModel.nextMinute(from: Date.now))...)
                .padding()
                .datePickerStyle(.compact)
            
            if viewModel.showDuplicateMeditationError || viewModel.showMaxMeditationError {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .frame(width: 28)
                    if viewModel.showDuplicateMeditationError {
                        Text("You already selected that time to meditate. Please select a different time.")
                            .font(.callout)
                            .foregroundColor(.red)
                    }
                    if viewModel.showMaxMeditationError {
                        Text("You may only choose up to \(viewModel.maxMeditationTimes) times to medidate per meditation. Please delete a meditation time before adding a new one.")
                            .font(.callout)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding()
            }
            
            List {
                ForEach(viewModel.datesToDisplay.indices, id: \.self) { i in
                    HStack {
                        Button {
                            viewModel.delete(at: i)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                        Text(viewModel.datesToDisplay[i])
                            .foregroundColor(viewModel.reflectionTimeComplete(from: i) ? .gray : Color(uiColor: .label))
                            .strikethrough(viewModel.reflectionTimeComplete(from: i), color: .black)
                    }
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        viewModel.delete(at: index)
                    }
                }
            }
            .listStyle(.plain)
            MarcusCommonButton(title: "Add Meditation Time") {
                Task {
                    await viewModel.insert(date: viewModel.selectedDate)
                }
            }
            .padding([.bottom])
        }
        .navigationTitle("Select Meditation Times")
        .navigationBarItems(leading: Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(uiColor: .label))
        }), trailing: Button(action: { viewModel.deleteAllDates() }, label: {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(viewModel.datesToDisplay.isEmpty ? .gray : .primary)
        })
            .disabled(viewModel.datesToDisplay.isEmpty)
        )
        .navigationBarBackButtonHidden()
        .alert(viewModel.alertInfo?.title ?? "", isPresented: $viewModel.showAlert, actions: {
            Button(viewModel.alertInfo?.acceptActionOption ?? "", role: .destructive) {
                _ = viewModel.alertInfo?.acceptAction?()
            }
            if let declineActionOption = viewModel.alertInfo?.declineActionOption {
                Button(declineActionOption, role: .cancel) {
                    viewModel.alertInfo?.declineAction?()
                }
            }
        }, message: {
            Text(viewModel.alertInfo?.message ?? "")
        })
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
        isShowingMeditationList = false
    }
}

//struct MeditationDatesView_Previews: PreviewProvider {
//
//    static var meditation: Meditation {
//        let meditation = Meditation(context: DataController.sharedInstance.container.viewContext)
//        meditation.localizedId = "01Be_unattached"
//        meditation.visitedAfterFinalTime = false
//        return meditation
//    }
////
//    static var previews: some View {
//        Group {
//            NavigationView {
//                MeditationDatesView(viewModel: MeditationDatesViewModel(dates: [], meditation: meditation, selectedDate: .now, notificationManager: LocalNotificationManager(), emotionDescription: EmotionDescription(context: DataController.sharedInstance.container.viewContext)))
//            }
//
//            NavigationView {
//                MeditationDatesView(viewModel: MeditationDatesViewModel(dates: [], meditation: meditation, selectedDate: .now, notificationManager: LocalNotificationManager(), emotionDescription: EmotionDescription(context: DataController.sharedInstance.container.viewContext)))
//            }
//            .previewInterfaceOrientation(.landscapeLeft)
//        }
//    }
//}
