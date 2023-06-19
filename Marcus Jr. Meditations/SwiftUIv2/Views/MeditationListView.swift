//
//  MeditationListView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationListView: View {
    
    let viewModel: MeditationListViewModel
    
    var body: some View {
        List() {
            
        }
        .navigationTitle(viewModel.emotionText)
    }
}

struct MeditationListView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationListView(viewModel: MeditationListViewModel(emotion: .courage))
    }
}
