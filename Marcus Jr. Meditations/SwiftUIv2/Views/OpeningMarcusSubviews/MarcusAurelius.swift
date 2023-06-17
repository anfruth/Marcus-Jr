//
//  MarcusAurelius.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 2/21/22.
//  Copyright © 2022 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MarcusAurelius: View {
    
    @Binding var showMarcus: Bool
    @Binding var showBeginButton: Bool
    
    let backgroundImageName: String

    var body: some View {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                showBeginButton = true
            }
        }
    }
}

struct MarcusAurelius_Previews: PreviewProvider {
    static var previews: some View {
        MarcusAurelius(showMarcus: .constant(true),
                       showBeginButton: .constant(false),
                       backgroundImageName: "Marcus-Aurelius")
    }
}
