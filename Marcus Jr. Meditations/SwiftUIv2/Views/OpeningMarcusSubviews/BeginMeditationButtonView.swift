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
    @Binding var navigationActive: Bool
    
    let buttonText: String
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: EmotionsView(viewModel: EmotionsViewModel()),
                           isActive: $navigationActive) { EmptyView() }
            
            MarcusCommonButton(title: buttonText) {
                navigationActive = true
            }
            .opacity(showBeginButton ? 1 : 0)
            .animation(.linear(duration: 2.0), value: showBeginButton ? 1 : 0)
        }
        .frame(height: 45)
    }
}

struct BeginMeditationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BeginMeditationButtonView(showBeginButton: .constant(true), navigationActive: .constant(false), buttonText: "Begin Meditations")
    }
}
