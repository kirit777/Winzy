//
//  VideoCallScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct VideoCallScreen: View {
    @State private var isMuted: Bool = false
    @State private var isCameraOn: Bool = true
    @State private var isSwitched: Bool = false
    
    var body: some View {
        ZStack {
            // Background Video Call (Other User)
            Image("otherUserBackground") // Placeholder for the other user's camera view
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .overlay(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom)) // Optional overlay for contrast
            
            VStack {
                // Navigation Bar with Back Button
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    
                    Spacer()
                    
                    Text("Video Call")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                
                Spacer()
                
                // Camera View for Logged-in User (User's own camera)
                VStack {
                    HStack {
                        Spacer()
                        
                        // Placeholder for the user's camera
                        Image("userCamera") // Replace with live camera feed
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .shadow(radius: 10)
                            .padding(10)
                    }
                    
                    Spacer()
                }
                
                // Bottom Control View for Video Call
                HStack {
                    // Mute Button
                    Button(action: {
                        isMuted.toggle()
                    }) {
                        Image(systemName: isMuted ? "mic.slash.fill" : "mic.fill")
                            .font(.title)
                            .foregroundColor(isMuted ? .red : .white)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    // Camera On/Off Button
                    Button(action: {
                        isCameraOn.toggle()
                    }) {
                        Image(systemName: isCameraOn ? "video.fill" : "video.slash.fill")
                            .font(.title)
                            .foregroundColor(isCameraOn ? .green : .red)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    // Switch Camera Button
                    Button(action: {
                        isSwitched.toggle()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    // End Call Button
                    Button(action: {
                        // End call action
                    }) {
                        Image(systemName: "phone.down.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                            .shadow(radius: 5)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
            }
        }
    }
}

struct VideoCallScreen_Previews: PreviewProvider {
    static var previews: some View {
        VideoCallScreen()
    }
}
