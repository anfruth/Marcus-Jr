//
//  MeditationListView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/17/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationListView: View {
    
    // TODO: Refactor out knowledge of emotion model from View -> VM
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: MeditationListViewModel
    
    var body: some View {
        VStack {
            if let meditationVM = viewModel.meditationVM {
                let meditationView = MeditationView(viewModel: meditationVM)
                NavigationLink(destination: meditationView, isActive: $viewModel.meditationSelected) { EmptyView() }
            }
            
            List(viewModel.meditationSummaries, id: \.self.0) { summary in
                VStack {
                    Spacer()
                    Button {
                        viewModel.selectMeditation(from: summary.1)
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(8)
                                .foregroundColor(Color(.secondarySystemBackground))
                                .shadow(radius: 5, x: 2, y: 3)
                            Text(summary.0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.top, .bottom], 10)
                                .padding([.leading, .trailing], 20)
                        }
                        Spacer(minLength: 5)
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)

        }
        .navigationTitle(viewModel.emotionText)
        .navigationBarItems(leading: Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(uiColor: .label))
        }))
        .navigationBarBackButtonHidden()
    }
}

//struct MeditationListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MeditationListView(viewModel: MeditationListViewModel(emotion: .loss, meditations:
//                                                                                                                                                    [Meditation(id: "00What_is"),
//                                                                                                                                                     Meditation(id: "01Be_unattached"),
//                                                                                                                                                     Meditation(id: "08Seek the")]))
//        }
//    }
//}
