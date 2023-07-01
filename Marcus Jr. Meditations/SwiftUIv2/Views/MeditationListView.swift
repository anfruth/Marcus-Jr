//
//  MeditationListView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationListView: View {
    
    // TODO: Refactor out knowledge of emotion model from View -> VM
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedEmotion: Emotion?
    @Binding var isShowingMeditationList: Bool
    
    let viewModel: MeditationListViewModel
    
    var body: some View {
        List(viewModel.meditations) { meditation in
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .cornerRadius(8)
                        .foregroundColor(Color(.secondarySystemBackground))
                        .shadow(radius: 5, x: 2, y: 3)
                    Text(meditation.summary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .bottom], 10)
                        .padding([.leading, .trailing], 20)
                }
                Spacer(minLength: 5)
            }
            .listRowSeparator(.hidden)
        }
        .navigationTitle(viewModel.emotionText)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(uiColor: .label))
        }))
        .listStyle(.plain)
        .onDisappear {
            selectedEmotion = nil
            isShowingMeditationList = false
        }
    }
}

struct MeditationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MeditationListView(selectedEmotion: .constant(.courage), isShowingMeditationList: .constant(true), viewModel: MeditationListViewModel(emotion: .loss, meditations:
                                                                                                                                                    [Meditation(id: "00What_is"),
                                                                                                                                                     Meditation(id: "01Be_unattached"),
                                                                                                                                                     Meditation(id: "08Seek the")]))
        }
    }
}
