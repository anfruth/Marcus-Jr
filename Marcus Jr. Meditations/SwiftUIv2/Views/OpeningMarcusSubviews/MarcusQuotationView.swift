//
//  MarcusQuotationView.swift
//  Marcus Jr. Meditations
//
//  Created by Andrew Fruth on 5/31/23.
//  Copyright © 2023 Andrew Fruth. All rights reserved.
//

import SwiftUI

struct MarcusQuotationView: View {
    
    @Binding var showMarcus: Bool
    
    let marcusQuotation: String
    let authorNotationText: String
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                HStack {
                    Spacer()
                    
                    VStack() {
                        Spacer()
                        Text(marcusQuotation)
                            .font(.title)
                            .padding([.leading, .trailing], 30)
                            .padding([.bottom], 20)
                        Text(authorNotationText)
                            .font(.headline)
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(minHeight: proxy.size.height)
                .opacity(showMarcus ? 0 : 1)
                .animation(.linear(duration: 3), value: showMarcus ? 0 : 1)
            }
        }
    }
}

struct MarcusQuotationView_Previews: PreviewProvider {
    static var previews: some View {
        MarcusQuotationView(showMarcus: .constant(false), marcusQuotation: "\"Men seek retirement in the country, on the sea-coast, in the mountains; and you too have frequent longings for such distractions. Yet surely this is great folly, since you may retire into yourself at any hour you please. Nowhere can a man find any retreat more quiet and more full of leisure than in his own soul; especially when there is that within it on which, if he but look, he is straightway quite at rest.\"", authorNotationText: "- Marcus Aurelius")
    }
}
