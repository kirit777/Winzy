//
//  AppWalkthroughScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct AppWalkthroughScreen: View {
    @State private var currentPage = 0
    let pages = [
        "Welcome to Winzy! Chat with friends and family.",
        "Make video calls with amazing features.",
        "Share your media and stay connected.",
        "Customize your app to match your style."
    ]
    @State private var isWalkthroughComplete = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient for the Walkthrough Screen
//                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .top, endPoint: .bottom)
//                    .edgesIgnoringSafeArea(.all)
                GradientBackgroundView()
                
                FloatingShapes()

                
                VStack {
                    // Onboarding Title with Floating Effect
                    Text("Welcome to Winzy!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .padding(.top, 50)
                        .scaleEffect(1 + CGFloat(currentPage) * 0.05)
                        .animation(.easeInOut(duration: 0.5), value: currentPage)
                    
                    // Animated Feature Description
                    Text(pages[currentPage])
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .opacity(1 - Double(currentPage) * 0.2)
                        .scaleEffect(1 + CGFloat(currentPage) * 0.02)
                        .animation(.easeInOut(duration: 0.5), value: currentPage)
                    
                    Spacer()
                    
                    // Page Indicator with Animation
                    HStack {
                        ForEach(0..<pages.count) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.5))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.5), value: currentPage)
                        }
                    }
                    
                    Spacer()
                    
                    // Skip Button with Floating Effect
                    Button(action: {
                        // Skip action
                        print("Skipped Walkthrough")
                        isWalkthroughComplete = true
                    }) {
                        Text("Skip")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 30)
                    .opacity(currentPage == pages.count - 1 ? 0 : 1)
                    
                    // Next Button for Walkthrough
                    HStack {
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                // Navigate to the main app screen
                                print("Walkthrough Completed")
                                isWalkthroughComplete = true
                            }
                        }) {
                            Text(currentPage == pages.count - 1 ? "Get Started!" : "Next")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        .padding(.bottom, 30)
                    }
                }
                .padding()
                
                NavigationLink(
                    destination: WinzyChatLoginScreen(),
                    isActive: $isWalkthroughComplete,
                    label: {
                        EmptyView() // Invisible view to trigger navigation
                    }
                )
                .hidden()
            }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct AppWalkthroughScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppWalkthroughScreen()
    }
}
