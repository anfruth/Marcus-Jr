//
//  BeginMeditationButtonView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/7/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct BeginMeditationButtonView: View {
    
    @Binding var showBeginButton: Bool
    
    let buttonText: String
    
    var body: some View {
        
        GeometryReader { proxy in
            HStack {
                Spacer()
                
                NavigationLink {
                    EmotionsView()
                } label: {
                    Text(buttonText)
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(width: proxy.size.width - 60, height: 45)
                }
                .background(.selection)
                .cornerRadius(8)
                
                Spacer()
            }
        }
        .frame(height: 45)
        .opacity(showBeginButton ? 1 : 0)
        .animation(.linear(duration: 2.0), value: showBeginButton ? 1 : 0)
        
        Spacer()
    }
}

struct BeginMeditationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BeginMeditationButtonView(showBeginButton: .constant(true), buttonText: "Begin Meditations")
    }
}
