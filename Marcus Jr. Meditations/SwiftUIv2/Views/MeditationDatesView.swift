//
//  MeditationDatesView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/1/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MeditationDatesView: View {
    
    @State var selectedDate: Date
    @StateObject var viewModel: MeditationDatesViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            DatePicker("Choose Time:", selection: $selectedDate)
                .padding()
                .datePickerStyle(.compact)
            if viewModel.showDuplicateMeditationError {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .frame(width: 28)
                    Text("You already selected that time to meditate. Please select a different time.")
                        .font(.callout)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
            }
            List {
                ForEach(viewModel.datesToDisplay.indices, id: \.self) { i in
                    HStack {
                        Button {
                            viewModel.delete(indexSet: IndexSet(integer: i))
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                        Text(viewModel.datesToDisplay[i])
                    }
                }
                .onDelete { indexSet in
                    viewModel.delete(indexSet: indexSet)
                }
            }
            .listStyle(.plain)
            MarcusCommonButton(title: "Add Meditation Time") {
                viewModel.insert(date: selectedDate)
            }
        }
        .navigationTitle("Select Meditation Times")
        .navigationBarItems(leading: Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(uiColor: .label))
        }))
        .navigationBarBackButtonHidden()
    }
}

struct MeditationDatesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                MeditationDatesView(selectedDate: .now, viewModel: MeditationDatesViewModel(dates: []))
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            NavigationView {
                MeditationDatesView(selectedDate: .now, viewModel: MeditationDatesViewModel(dates: []))
                    .navigationBarTitleDisplayMode(.inline)
            }
            .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
