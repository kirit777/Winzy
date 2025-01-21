//
//  CustomCameraScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//
import SwiftUI

struct CustomCameraScreen: View {
    @State private var isRecording: Bool = false
    @State private var isFrontCamera: Bool = true
    @State private var capturedImage: Image? = nil
    @State private var recentImages: [String] = ["image1", "image2", "image3"] // Placeholder for recent images
    @State private var cameraTapped: Bool = false

    var body: some View {
        ZStack {
            // Full-screen Camera View (Placeholder for live camera feed)
            Rectangle()
                .foregroundColor(.black)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    capturedImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                )

            VStack {
                // Floating Navigation Bar (with back action)
                HStack {
                    Button(action: {
                        // Cancel action
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }

                    Spacer()
                    
                    Text("Camera")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                .offset(y: cameraTapped ? 0 : -30)  // Floating animation effect for the nav bar

                Spacer()
                
                // Floating Capture Button (Record or Capture)
                VStack {
                    HStack {
                        Spacer()
                        
                        // Capture Button
                        Button(action: {
                            cameraTapped.toggle()
                            isRecording.toggle()
                        }) {
                            Image(systemName: isRecording ? "stop.fill" : "record.circle.fill")
                                .font(.system(size: 70))
                                .foregroundColor(isRecording ? .red : .green)
                                .padding()
                                .background(Circle().fill(Color.white.opacity(0.2)))
                                .shadow(radius: 10)
                        }
                    }
                    .padding(.bottom, 100)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(radius: 15)
                    .offset(y: cameraTapped ? 50 : 0)  // Floating animation effect for the button
                }

                // Floating List of Recent Images and Videos
                VStack {
                    Text("Recent Media")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(recentImages, id: \.self) { image in
                                VStack {
                                    Image(image) // Placeholder for recent media
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(10)
                                    Text("Video") // Replace with type (Image/Video)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                .padding(5)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(15)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .offset(y: cameraTapped ? 100 : 0) // Floating animation for the media list
                }

                Spacer()
                
                // Floating Switch Camera Button
                VStack {
                    Button(action: {
                        isFrontCamera.toggle()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                            .shadow(radius: 10)
                    }
                }
                .padding(.bottom, 30)
                .offset(y: cameraTapped ? 150 : 0)  // Floating animation effect for switch camera button
            }
        }
        .onAppear {
            // Set up camera and other configurations here
        }
    }
}

struct CustomCameraScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomCameraScreen()
    }
}
