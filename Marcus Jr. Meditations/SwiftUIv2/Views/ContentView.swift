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
    
    private var marcusQuotation = MarcusManager().quotation
    private let backgroundImageName = "Marcus-Aurelius"
    
    var body: some View {

        ZStack {
            GeometryReader { proxy in
                Image(backgroundImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            .opacity(showMarcus ? 1 : 0)
            .animation(.linear(duration: 3), value: showMarcus ? 1 : 0)
            .onAppear {
                showMarcus = false
            }
            
            VStack {
                GeometryReader { proxy in
                    ScrollView {
                        
                        VStack() {
                            Spacer()
                            Text(marcusQuotation)
                                .font(.title)
                                .padding([.leading, .trailing], 30)
                                .padding([.bottom], 20)
                            Text("- Marcus Aurelius")
                                .font(.headline)
                            Spacer()
                        }
                        .frame(minHeight: proxy.size.height)
                        .opacity(showMarcus ? 0 : 1)
                        .animation(.linear(duration: 3), value: showMarcus ? 0 : 1)
                        
                    }
                }
                
                GeometryReader { proxy in
                    HStack {
                        Spacer()
                        
                        Button {
                            showMarcus.toggle()
                        } label: {
                            Text("Begin Meditations")
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                        }
                        .frame(width: proxy.size.width - 60, height: 45)
                        .background(.selection)
                        .cornerRadius(8)
                        
                        Spacer()
                    }
                }
                .frame(height: 45)
                
                Spacer()
            }
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
