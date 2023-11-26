//
//  MeditationDateWarning.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 11/25/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationDateWarning: View {
    
    @StateObject var viewModel: MeditationDatesViewModel
    
    var body: some View {
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
}

struct MeditationDateWarning_Previews: PreviewProvider {
    
    static var meditation: Meditation {
        let meditation = Meditation(context: DataController.sharedInstance.container.viewContext)
        meditation.localizedId = "01Be_unattached"
        meditation.visitedAfterFinalTime = false
        return meditation
    }
    
    static var viewModel = MeditationDatesViewModel(dates: [Date.now], meditation: meditation, selectedDate: .now, notificationManager: LocalNotificationManager(), emotionDescription: EmotionDescription(context: DataController.sharedInstance.container.viewContext))
    
    static var previews: some View {
        MeditationDateWarning(viewModel: viewModel)
    }
}
