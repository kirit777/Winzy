//
//  ChatSettingsScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct ChatSettingsScreen: View {
    @State private var muteNotifications = false
    @State private var customNotifications = false
    @State private var isBlocked = false
    @State private var isPinned = false
    @State private var showWallpaperPicker = false
    @State private var wallpaper = "defaultWallpaper"
    
    var body: some View {
        ZStack {
            // Background with custom wallpaper
            Image(wallpaper)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 10)
            
            VStack {
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
                    Text("Chat Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        // More options action
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Settings List
                ScrollView {
                    VStack(spacing: 20) {
                        // Mute Notifications Toggle
                        settingsRow(
                            title: "Mute Notifications",
                            description: muteNotifications ? "Notifications are muted" : "Notifications are on",
                            icon: "bell.slash.fill",
                            toggle: $muteNotifications
                        )
                        
                        // Customize Notifications Toggle
                        settingsRow(
                            title: "Customize Notifications",
                            description: customNotifications ? "Custom sounds are enabled" : "Use default notification sound",
                            icon: "speaker.wave.2.fill",
                            toggle: $customNotifications
                        )
                        
                        // Set Custom Wallpaper Button
                        settingsRow(
                            title: "Set Custom Wallpaper",
                            description: "Change the background of this chat",
                            icon: "photo.fill",
                            action: {
                                showWallpaperPicker.toggle()
                            }
                        )
                        
                        // Clear Chat History Button
                        settingsRow(
                            title: "Clear Chat History",
                            description: "Delete all messages in this chat",
                            icon: "trash.fill",
                            action: {
                                // Add Clear Chat History Action
                            }
                        )
                        
                        // Block/Unblock User Button
                        settingsRow(
                            title: isBlocked ? "Unblock User" : "Block User",
                            description: isBlocked ? "You can message this user again" : "You won't receive messages from this user",
                            icon: "hand.thumbsdown.fill",
                            action: {
                                isBlocked.toggle()
                            }
                        )
                        
                        // Pin Chat to Top Toggle
                        settingsRow(
                            title: isPinned ? "Unpin Chat" : "Pin Chat to Top",
                            description: isPinned ? "Chat is unpinned" : "Chat is pinned to the top",
                            icon: "pin.fill",
                            toggle: $isPinned
                        )
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .actionSheet(isPresented: $showWallpaperPicker) {
            ActionSheet(
                title: Text("Select Wallpaper"),
                buttons: [
                    .default(Text("Wallpaper 1")) {
                        wallpaper = "wallpaper1"
                    },
                    .default(Text("Wallpaper 2")) {
                        wallpaper = "wallpaper2"
                    },
                    .default(Text("Wallpaper 3")) {
                        wallpaper = "wallpaper3"
                    },
                    .cancel()
                ]
            )
        }
        .animation(.spring(), value: muteNotifications)
    }
    
    // Reusable settings row with icon, title, description, toggle or action
    private func settingsRow(title: String, description: String, icon: String, toggle: Binding<Bool>? = nil, action: (() -> Void)? = nil) -> some View {
        HStack {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue.opacity(0.6))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Toggle or Action Button
            if let toggle = toggle {
                Toggle("", isOn: toggle)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding(.trailing, 20)
            } else if let action = action {
                Button(action: action) {
                    Text("Change")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal, 20)
    }
}

struct ChatSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingsScreen()
    }
}
