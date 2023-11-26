//
//  MeditationContentContainer.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 11/25/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import Foundation
import SwiftUI

struct MeditationContentContainer: View {
    
    @StateObject var viewModel: MeditationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                InnerMeditationViewFormat(title: "Quotation:", description: viewModel.quotation)
                
                if viewModel.commentaryAvailable {
                    InnerMeditationViewFormat(title: "Commentary:", description: viewModel.commentary)
                }
                
                if viewModel.actionAvailable {
                    InnerMeditationViewFormat(title: "Action:", description: viewModel.action)
                }
            }
        }
        .padding(.bottom)
        .navigationTitle(viewModel.enchiridionChapter)
        .navigationBarItems(leading: Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(uiColor: .label))
        }))
        .navigationBarBackButtonHidden()
    }
}
