//
//  EmotionsView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 6/7/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct EmotionsView: View {
    
    private let navTitle = "Choose Emotion"
    
    var body: some View {

        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 2), spacing: 0) {
                    ForEach(Emotion.allCases.indices, id: \.self) { index in
                        NavigationLink {
                            
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(getFillColor(from: index))
                                    .frame(maxWidth: .infinity, minHeight: 175)
                                Text(Emotion.allCases[index].rawValue)
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }

            }
            .navigationTitle(navTitle)
            .ignoresSafeArea(edges: [.leading, .trailing, .bottom])
        }
        .navigationBarBackButtonHidden(true)
    
    }
    
    private func getFillColor(from index: Int) -> Color {
        if (index + 1) % 3 == 2 {
            return Color(red:0.30, green:0.39, blue:0.55)
        } else if (index + 1) % 3 == 1 {
            return Color(red:0.16, green:0.21, blue:0.33)
        } else {
            return Color(red:0.12, green:0.12, blue:0.15)
        }
    }
}

struct EmotionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmotionsView()
            EmotionsView()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
