//
//  EmotionsView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/7/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionsView: View {
    
    @State private var emotionsInGrid = Emotion.allCases
    @State private var selectedEmotion: Emotion?
    @State private var isShowingMeditationList = false
    
    private let navTitle = "Choose Emotion"
    let viewModel: EmotionsViewModel
    
    let animation = Animation.easeOut(duration: 0.8)
    
    var body: some View {
        
        GeometryReader { proxy in
            NavigationView {
                ScrollView(emotionsInGrid.count != 1 ? [.vertical] : []) {
                    
                    if let selectedEmotion {
                        let viewModel = MeditationListViewModel(emotion: selectedEmotion,
                                                                meditations: viewModel.meditations(from: selectedEmotion))
                        let destination = MeditationListView(selectedEmotion: $selectedEmotion, isShowingMeditationList: $isShowingMeditationList, viewModel: viewModel)
                        
                        NavigationLink(destination: destination, isActive: $isShowingMeditationList) { EmptyView() }
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: emotionsInGrid.count != 1 ? 2 : 1), spacing: 0) {
                        if emotionsInGrid.count != 1 {
                            ForEach(emotionsInGrid.indices, id: \.self) { index in
                                
                                Button {
                                    if emotionsInGrid.count != 1 {
                                        withAnimation(animation) {
                                            selectedEmotion = Emotion.allCases[index]
                                            emotionsInGrid = [selectedEmotion ?? .anger]
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                            isShowingMeditationList = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                emotionsInGrid = Emotion.allCases
                                            }
                                        }
                                    }
                                    
                                } label: {
                                    ZStack {
                                        Rectangle()
                                            .fill(getFillColor(from: emotionsInGrid[index]))
                                            .frame(minHeight: emotionsInGrid.count != 1 ? 175 : proxy.size.height)
                                        Text(emotionsInGrid[index].rawValue)
                                            .font(emotionsInGrid.count != 1 ? .title2 : .largeTitle)
                                            .foregroundColor(.white)
                                    }
                                }
                                .disabled(emotionsInGrid.count == 1)
                            }
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(getFillColor(from: selectedEmotion ?? .anger))
                                    .frame(minHeight: emotionsInGrid.count != 1 ? 175 : proxy.size.height)
                                Text(selectedEmotion?.rawValue ?? Emotion.anger.rawValue)
                                    .font(emotionsInGrid.count != 1 ? .title2 : .largeTitle)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .navigationTitle(emotionsInGrid.count != 1 ? "Choose Emotion" : "")
                .ignoresSafeArea(edges: emotionsInGrid.count != 1 ? [.leading, .trailing, .bottom] : [.all])
            }
            .navigationBarBackButtonHidden(true)
        }
        .ignoresSafeArea()
    }
    
    private func getFillColor(from emotion: Emotion) -> Color {
        switch emotion {
        case .loss, .anxiety, .discipline:
            return Color(red:0.30, green:0.39, blue:0.55)
        case .anger, .envy, .empathy:
            return Color(red:0.16, green:0.21, blue:0.33)
        case .sadness, .persevere, .courage:
            return Color(red:0.12, green:0.12, blue:0.15)
        }
    }
}

struct EmotionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmotionsView(viewModel: EmotionsViewModel())
            EmotionsView(viewModel: EmotionsViewModel())
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
