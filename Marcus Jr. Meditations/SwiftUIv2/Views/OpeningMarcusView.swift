//
//  OpeningMarcusView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/5/22.
//  Copyright © 2022 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct OpeningMarcusView: View, MeditationNavigating {
    
    @State private var showMarcus = true
    @State private var showBeginButton = false
    @State private var navigationActive = false

    @EnvironmentObject var routingState: RoutingState
    
    var marcusQuotation: String
    
    // TODO: Add Strings file.
    private let backgroundImageName = "Marcus-Aurelius"
    private let authorNotationText = "- Marcus Aurelius"
    private let buttonText = "Begin Meditations"
    
    var body: some View {
        NavigationView {
            ZStack {
                MarcusAurelius(showMarcus: $showMarcus,
                               showBeginButton: $showBeginButton,
                               backgroundImageName: backgroundImageName)
                
                VStack {
                    MarcusQuotationView(showMarcus: $showMarcus, marcusQuotation: marcusQuotation, authorNotationText: authorNotationText)
                        .padding([.top])
                    
                    BeginMeditationButtonView(showBeginButton: $showBeginButton, navigationActive: $navigationActive, buttonText: buttonText)
                        .padding([.top, .bottom])
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if routingState.isActive {
                if let meditationId = routingState.meditationId, let emotionText = routingState.emotionText {
                    route(using: meditationId, through: emotionText)
                }
            }
        }
        .onChange(of: routingState.isActive) { isActive in
            if let meditationId = routingState.meditationId, let emotionText = routingState.emotionText, isActive {
                route(using: meditationId, through: emotionText)
            }
        }
    }
    
    func route(using meditationId: String, through emotionText: String) {
        navigationActive = true
    }
    
}

struct OpeningMarcusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OpeningMarcusView(marcusQuotation: "\"Men seek retirement in the country, on the sea-coast, in the mountains; and you too have frequent longings for such distractions. Yet surely this is great folly, since you may retire into yourself at any hour you please. Nowhere can a man find any retreat more quiet and more full of leisure than in his own soul; especially when there is that within it on which, if he but look, he is straightway quite at rest.\"")
                .environmentObject(NotificationsReceiver.sharedInstance.routingState)
            
            OpeningMarcusView(marcusQuotation: "\"Men seek retirement in the country, on the sea-coast, in the mountains; and you too have frequent longings for such distractions. Yet surely this is great folly, since you may retire into yourself at any hour you please. Nowhere can a man find any retreat more quiet and more full of leisure than in his own soul; especially when there is that within it on which, if he but look, he is straightway quite at rest.\"")
                .previewInterfaceOrientation(.landscapeLeft)
                .environmentObject(NotificationsReceiver.sharedInstance.routingState)
        }
    }
}
