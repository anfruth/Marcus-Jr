//
//  MeditationView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/26/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationView: View {
    
    let viewModel: MeditationViewModel
    
    @Environment(\.dismiss) private var dismiss
    @Binding var meditationSelected: Bool
    
    var body: some View {
        ScrollView {
            Text(viewModel.quotation)
                .padding()
        }
        .navigationTitle(viewModel.enchiridionChapter)
        .navigationBarItems(leading: Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(uiColor: .label))
        }))
        .navigationBarBackButtonHidden()
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView(viewModel: MeditationViewModel(meditation: Meditation(id: "01Be_unattached")), meditationSelected: .constant(true))
    }
}
