//
//  ThemeCustomizationScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct ThemeCustomizationScreen: View {
    @State private var selectedTheme = "Light"
    @State private var accentColor: Color = .blue
    @State private var wallpaperImage: Image? = nil
    @State private var customTheme: Bool = false
    
    var body: some View {
        ZStack {
            // Background Gradient
//            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
            
            GradientBackgroundView()
            
            FloatingShapes()

            
            VStack(spacing: 30) {
                // Navigation Bar
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Theme & Customization")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                
                // Theme Switcher Section
                VStack(alignment: .leading) {
                    Text("Select Theme")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Button(action: {
                            selectedTheme = "Light"
                            customTheme = false
                        }) {
                            Text("Light")
                                .font(.subheadline)
                                .padding()
                                .background(selectedTheme == "Light" ? Color.white.opacity(0.5) : Color.clear)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            selectedTheme = "Dark"
                            customTheme = false
                        }) {
                            Text("Dark")
                                .font(.subheadline)
                                .padding()
                                .background(selectedTheme == "Dark" ? Color.white.opacity(0.5) : Color.clear)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            selectedTheme = "Custom"
                            customTheme = true
                        }) {
                            Text("Custom")
                                .font(.subheadline)
                                .padding()
                                .background(selectedTheme == "Custom" ? Color.white.opacity(0.5) : Color.clear)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
                
                // Accent Color Customization Section
                VStack(alignment: .leading) {
                    Text("Accent Color")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    HStack {
                        ColorPicker("Pick Accent Color", selection: $accentColor)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Wallpaper Customization Section
                VStack(alignment: .leading) {
                    Text("Set Wallpaper")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    Button(action: {
                        // Wallpaper selection action
                        wallpaperImage = Image(systemName: "photo") // Example image picker
                    }) {
                        Text("Choose Wallpaper")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(10)
                    }
                    
                    if wallpaperImage != nil {
                        wallpaperImage?
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.top, 10)
                    }
                }
                .padding()
                
                // Apply Button
                Spacer()
                Button(action: {
                    // Apply customizations action
                }) {
                    Text("Apply Changes")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

struct ThemeCustomizationScreen_Previews: PreviewProvider {
    static var previews: some View {
        ThemeCustomizationScreen()
    }
}
