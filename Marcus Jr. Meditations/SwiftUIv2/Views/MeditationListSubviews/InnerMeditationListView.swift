//
//  InnerMeditationListView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 10/15/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct InnerMeditationListView: View {
    
    @StateObject var viewModel: MeditationListViewModel
    let animation: Animation
    
    var body: some View {
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
                    MeditationListCellView(summary: summary)
                    Spacer(minLength: 5)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct InnerMeditationListView_Previews: PreviewProvider {
    
    static var emotion: EmotionDescription {
        let emotionDesc = EmotionDescription(context: DataController.sharedInstance.container.viewContext)
        emotionDesc.emotion = "Loss"
        return emotionDesc
    }
    
    static var previews: some View {
        InnerMeditationListView(viewModel: MeditationListViewModel(emotionDescription: emotion, notificationManager: LocalNotificationManager()), animation: .linear(duration: 1.0))
    }
}
