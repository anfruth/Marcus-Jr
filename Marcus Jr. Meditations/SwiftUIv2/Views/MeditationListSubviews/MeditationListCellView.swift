//
//  MeditationListCellView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 10/14/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationListCellView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let summary: MeditationListViewModel.Summary
    
    var body: some View {
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
    }
}

struct MeditationListCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MeditationListCellView(summary: MeditationListViewModel.Summary(meditationID: NSLocalizedString("01Be_unattached", comment: "Meditation Summary"), index: 0, isComplete: false))

            MeditationListCellView(summary: MeditationListViewModel.Summary(meditationID: NSLocalizedString("01Be_unattached", comment: "Meditation Summary"), index: 0, isComplete: true))
            
        }
    }
}
