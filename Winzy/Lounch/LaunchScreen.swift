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
                // Animated Icon & App Name
                VStack {
                    // Icon with animation
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: scale)
                    
                    // App Name
                    Text("Winzy")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: scale)
                        .onAppear {
                            // Trigger animation when the screen appears
                            scale = 1.2
                            opacity = 1.0
                        }
                }
                .padding(.top, 50)
                
                Spacer()
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
