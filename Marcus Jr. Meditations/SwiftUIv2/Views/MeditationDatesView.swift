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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                DatePicker("Select Meditation Times", selection: $selectedDate)
                    .padding()
                    .datePickerStyle(.graphical)
                List {
                    
                }
            }
            MarcusCommonButton(title: "Add Meditation Time") {
                
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
                MeditationDatesView(selectedDate: .now)
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            NavigationView {
                MeditationDatesView(selectedDate: .now)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
