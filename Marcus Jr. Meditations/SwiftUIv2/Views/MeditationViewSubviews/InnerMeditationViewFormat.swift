//
//  InnerMeditationViewFormat.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 11/25/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct InnerMeditationViewFormat: View {
    
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(title)
                    .bold()
                Spacer()
            }
            Text(description)
                .padding()
        }
    }
}

struct InnerMeditationViewFormat_Previews: PreviewProvider {
    static var previews: some View {
        InnerMeditationViewFormat(title: "Quotation:", description: "Thus spoke zarafruthstra")
    }
}
