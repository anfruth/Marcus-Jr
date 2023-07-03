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
    
    @State private var navigationActive = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            ScrollView {
                Text("Quotation:")
                    .bold()
                Text(viewModel.quotation)
                    .padding()
                
                if viewModel.commentaryAvailable {
                    Text("Commentary:")
                        .bold()
                    Text(viewModel.commentary)
                        .padding()
                }
                
                if viewModel.actionAvailable {
                    Text("Action:")
                        .bold()
                    Text(viewModel.action)
                        .padding()
                }
            }
            .padding([.top, .bottom])
            .navigationTitle(viewModel.enchiridionChapter)
            .navigationBarItems(leading: Button(action: { dismiss() }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(uiColor: .label))
            }))
            .navigationBarBackButtonHidden()
            
            NavigationLink(destination: MeditationDatesView(selectedDate: .now),
                           isActive: $navigationActive) { EmptyView() }
            
            MarcusCommonButton(title: "Set Meditation Times") {
                navigationActive = true
            }
            
            Spacer()
        }
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MeditationView(viewModel: MeditationViewModel(meditation: Meditation(id: "01Be_unattached")))
        }
    }
}
