//
//  MeditationPreviewText.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 10/15/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationPreviewText: View {
    
    @StateObject var viewModel: MeditationListViewModel
    
    var body: some View {
        Text(viewModel.meditationSummaries[0].meditationID)
            .font(.title)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct MeditationPreviewText_Previews: PreviewProvider {
    
    static var emotion: EmotionDescription {
        let emotionDesc = EmotionDescription(context: DataController.sharedInstance.container.viewContext)
        emotionDesc.emotion = "Loss"
        return emotionDesc
    }
    
    static var previews: some View {
        MeditationPreviewText(viewModel: MeditationListViewModel(emotionDescription: emotion, notificationManager: LocalNotificationManager()))
    }
}
