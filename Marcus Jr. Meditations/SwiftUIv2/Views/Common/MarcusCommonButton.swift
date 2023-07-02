//
//  MarcusCommonButton.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 7/1/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MarcusCommonButton<T: View>: View {
    
    let title: String
    var destination: T
    
    var body: some View {
        GeometryReader { proxy in
            HStack {
                Spacer()
                
                NavigationLink {
                    destination
                } label: {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(width: proxy.size.width - 60, height: 45)
                }
                .background(.selection)
                .cornerRadius(8)
                
                Spacer()
            }
            .shadow(radius: 5, x: 2, y: 3)
        }
        .frame(height: 45)
    }
}

struct MarcusCommonButton_Previews: PreviewProvider {
    static var previews: some View {
        MarcusCommonButton<EmotionsView>(title: "To Meditation List", destination: EmotionsView(viewModel: EmotionsViewModel()))
    }
}
