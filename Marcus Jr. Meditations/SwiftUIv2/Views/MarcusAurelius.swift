////
////  MarcusAurelius.swift
////  Marcus Jr. Meditations
////
////  Created by Andrew Fruth on 2/21/22.
////  Copyright © 2022 Andrew Fruth. All rights reserved.
////
//
//import SwiftUI
//
//struct MarcusAurelius: View {
//
//    @State var showMarcus: Bool
//    let fullWidthWithSafeArea: CGFloat
//    let fullHeightWithSafeArea: CGFloat
//
//    var body: some View {
//        Image("Marcus-Aurelius")
//            .resizable()
//            .scaledToFill()
//            .opacity(showMarcus ? 1 : 0)
//            .animation(.linear(duration: 3), value: showMarcus ? 1 : 0)
//            .onAppear {
//                showMarcus = false
//                //MeditationSpeech(text: marcusQuotation).read()
//            }
//            .frame(width: fullWidthWithSafeArea, height: fullHeightWithSafeArea)
//
//    }
//}
//
//struct MarcusAurelius_Previews: PreviewProvider {
//    static var previews: some View {
//        MarcusAurelius()
//    }
//}
