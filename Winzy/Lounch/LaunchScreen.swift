//
//  LaunchScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    @State private var dropW = false
    @State private var showLetters = false
    
    let letters = Array("inzy") // Letters that slide in
    
    var body: some View {
        ZStack {
            // Background Gradient
//            LinearGradient(
//                gradient: Gradient(colors: [Color.purple, Color.blue, Color.pink]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .edgesIgnoringSafeArea(.all)
            
            GradientBackgroundView()
            
            FloatingShapes()

            
            VStack {
                HStack(spacing: 5) {
                    Text("W")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: dropW ? 0 : -300) // Drop from top
                        .animation(.interpolatingSpring(stiffness: 200, damping: 10).delay(0.1), value: dropW)
                    
                    
                    HStack(spacing: 2) {
                        ForEach(letters.indices, id: \.self) { index in
                            Text(String(letters[index]))
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.white)
                                .offset(x: showLetters ? 0 : 50) // Slide from right
                                .opacity(showLetters ? 1 : 0) // Fade-in
                                .animation(.easeOut(duration: 0.3).delay(0.4 + Double(index) * 0.2), value: showLetters)
                        }
                    }
                }
                .padding(.top, 100) // Add padding to simulate ground
            }
            .onAppear {
                dropW = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showLetters = true
                }
            }
        }
        .onAppear {
            // Trigger initial animation
            scale = 1.2
            opacity = 1.0
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
