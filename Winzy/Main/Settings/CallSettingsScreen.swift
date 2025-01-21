//
//  CallSettingsScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct CallSettingsScreen: View {
    @State private var videoQuality = "Medium"
    @State private var noiseSuppressionEnabled = true
    @State private var cameraEnabled = true
    @State private var microphoneEnabled = true
    @State private var cameraResolution = "1080p"

    var body: some View {
        ZStack {
            // Background Gradient for Crazy Theme
//            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.pink]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
            
            GradientBackgroundView()
            
            FloatingShapes()

            
            VStack {
                // Title with Floating Animation
                Text("Voice & Video Call Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                    .scaleEffect(1 + CGFloat(videoQuality == "Medium" ? 0.05 : 0.0))
                    .animation(.easeInOut(duration: 0.5), value: videoQuality)
                
                Spacer()
                
                // Video Quality Setting
                SettingsRowView(title: "Video Quality", value: $videoQuality, options: ["Low", "Medium", "High"])
                
                // Noise Suppression Toggle
                SettingsToggleRowView(title: "Background Noise Suppression", isOn: $noiseSuppressionEnabled)
                
                // Camera and Microphone Toggles
                SettingsToggleRowView(title: "Enable Camera", isOn: $cameraEnabled)
                SettingsToggleRowView(title: "Enable Microphone", isOn: $microphoneEnabled)
                
                // Camera Resolution Setting
                SettingsRowView(title: "Camera Resolution", value: $cameraResolution, options: ["720p", "1080p", "4K"])
                
                Spacer()
                
                // Save Button with Crazy Design
                Button(action: {
                    // Save Settings Action
                    print("Settings saved.")
                }) {
                    Text("Save Settings")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
    }
}

struct SettingsRowView: View {
    var title: String
    @Binding var value: String
    var options: [String]
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
            
            Spacer()
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        value = option
                    }
                }
            } label: {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct SettingsToggleRowView: View {
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle(isOn: $isOn) {
                Text(isOn ? "Enabled" : "Disabled")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .orange))
            .frame(width: 100)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct CallSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CallSettingsScreen()
    }
}
