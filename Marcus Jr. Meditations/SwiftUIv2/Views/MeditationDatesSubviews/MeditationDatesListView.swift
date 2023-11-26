//
//  MeditationDatesListView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 11/25/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationDatesListView: View {
    
    @StateObject var viewModel: MeditationDatesViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
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
                        .foregroundColor(viewModel.reflectionTimeComplete(from: i) ? Color(uiColor: .systemGray) : Color(uiColor: .label))
                        .strikethrough(viewModel.reflectionTimeComplete(from: i), color: colorScheme == .light ? .black : .white)
                }
            }
            .onDelete { indexSet in
                if let index = indexSet.first {
                    viewModel.delete(at: index)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct MeditationDatesListView_Previews: PreviewProvider {
    
    static var meditation: Meditation {
        let meditation = Meditation(context: DataController.sharedInstance.container.viewContext)
        meditation.localizedId = "01Be_unattached"
        meditation.visitedAfterFinalTime = false
        return meditation
    }
    
    static var viewModel: MeditationDatesViewModel = MeditationDatesViewModel(dates: [Date.now], meditation: meditation, selectedDate: .now, notificationManager: LocalNotificationManager(), emotionDescription: EmotionDescription(context: DataController.sharedInstance.container.viewContext))
    
    static var previews: some View {
        MeditationDatesListView(viewModel: viewModel)
    }
}
