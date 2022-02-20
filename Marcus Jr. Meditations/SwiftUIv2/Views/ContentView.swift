//
//  ContentView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/5/22.
//  Copyright © 2022 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showMarcus = true
    var marcusQuotation = MarcusManager().quotation
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let fullWidthWithSafeArea = geometry.size.width + geometry.safeAreaInsets.leading + geometry.safeAreaInsets.trailing
            let fullHeightWithSafeArea = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
            
            ZStack() {
                
                let heightOfBeginButton: CGFloat = 100
                let quoteAreaHeight = geometry.size.height + geometry.safeAreaInsets.top - heightOfBeginButton
                
                Image("Marcus-Aurelius")
                    .resizable()
                    .scaledToFill()
                    .opacity(showMarcus ? 1 : 0)
                    .animation(.linear(duration: 3), value: showMarcus ? 1 : 0)
                    .onAppear {
                        showMarcus = false
                    }
                    .frame(width: fullWidthWithSafeArea, height: fullHeightWithSafeArea)

                VStack(spacing: 0) {
                    
                    VStack {
                        Spacer()
                        Text(marcusQuotation).padding(50)
                        Spacer()
                    }
                    .opacity(showMarcus ? 0 : 1)
                    .animation(.linear(duration: 3), value: showMarcus ? 0 : 1)
                    .frame(width: geometry.size.width, height: quoteAreaHeight)
                    
                    
                    Button {
                        showMarcus.toggle()
                    } label: {
                        Text("Begin Marcus Jr. Meditations")
                            .foregroundColor(Color.white)
                            .font(.title2)

                    }
                    .frame(width: fullWidthWithSafeArea, height: heightOfBeginButton)
                    .background(Color.blue)

                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: fullWidthWithSafeArea, height: geometry.safeAreaInsets.bottom)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)

            }
            .frame(width: fullWidthWithSafeArea, height: fullHeightWithSafeArea)
            .ignoresSafeArea()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 15.0, *) {
                ContentView()
                    .previewInterfaceOrientation(.landscapeLeft)
            } else {
                // Fallback on earlier versions
            }
            ContentView()
        }
    }
}
