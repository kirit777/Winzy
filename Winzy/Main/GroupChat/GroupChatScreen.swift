//
//  GroupChatScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct GroupChatScreen: View {
    @State private var groupName = "Awesome Chat"
    @State private var showGroupSettings = false
    @State private var showMediaPicker = false
    @State private var showDocumentPicker = false
    @State private var muteNotifications = false
    @State private var groupWallpaper = "defaultWallpaper"
    
    let demoMessages = [
        "Hey everyone, let's chat!",
        "Check out this funny meme!",
        "Does anyone know the meeting time?",
        "Can we schedule a call?"
    ]
    
    var body: some View {
        ZStack {
            // Background with custom wallpaper
            Image(groupWallpaper)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 10)
            
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        // Back Action
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text(groupName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        showGroupSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Group Chat Messages
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(demoMessages, id: \.self) { message in
                            HStack {
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .padding(10)
                                    .background(Color.white.opacity(0.6))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text("User Name")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(message)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .padding(.top, 2)
                                }
                                Spacer()
                                Text("2m ago")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(15)
                        }
                    }
                    .padding(.top)
                }
                
                Spacer()
                
                // Bottom Floating View for Sending Messages and Media
                HStack {
                    // Media Button (Camera/Images)
                    Button(action: {
                        showMediaPicker.toggle()
                    }) {
                        Image(systemName: "camera.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Message Textfield
                    TextField("Type a message...", text: .constant(""))
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(15)
                        .frame(height: 45)
                    
                    Spacer()
                    
                    // Send Button
                    Button(action: {
                        // Send message logic
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Microphone Button (Voice Message)
                    Button(action: {
                        // Voice message logic
                    }) {
                        Image(systemName: "mic.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showMediaPicker) {
            MediaPickerView()
        }
        .actionSheet(isPresented: $showGroupSettings) {
            ActionSheet(
                title: Text("Group Settings"),
                buttons: [
                    .default(Text("Change Group Name")) {
                        // Action to change group name
                    },
                    .default(Text("Add/Remove Members")) {
                        // Action to add or remove members
                    },
                    .default(Text("Change Group Wallpaper")) {
                        // Action to change group wallpaper
                    },
                    .default(Text("Mute Notifications")) {
                        muteNotifications.toggle()
                    },
                    .cancel()
                ]
            )
        }
    }
}

struct MediaPickerView: View {
    var body: some View {
        VStack {
            Button(action: {
                // Select image/video
            }) {
                Text("Select Media")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Button(action: {
                // Select document
            }) {
                Text("Select Document")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
    }
}

struct GroupChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatScreen()
    }
}
