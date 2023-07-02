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
    
    var body: some View {
        DatePicker("", selection: $selectedDate)
            .padding()
            .datePickerStyle(.graphical)
    }
}

struct MeditationDatesView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationDatesView(selectedDate: .now)
    }
}
