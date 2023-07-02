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

    var body: some View {
        VStack {
            ScrollView {
                Text("Quotation:")
                    .bold()
                    .padding()
                Text(viewModel.quotation)
                    .padding()
                Text("Commentary:")
                    .bold()
                    .padding()
                Text(viewModel.commentary)
                    .padding()
                Text("Action:")
                    .bold()
                    .padding()
                Text(viewModel.action)
                    .padding()
            }
            .padding([.top, .bottom])
            .navigationTitle(viewModel.enchiridionChapter)
            .navigationBarItems(leading: Button(action: { dismiss() }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(uiColor: .label))
            }))
            .navigationBarBackButtonHidden()
            
            MarcusCommonButton(title: "Set Meditation Times", destination: MeditationDatesView(selectedDate: .now))
            
            Spacer()
        }
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView(viewModel: MeditationViewModel(meditation: Meditation(id: "01Be_unattached")))
    }
}
