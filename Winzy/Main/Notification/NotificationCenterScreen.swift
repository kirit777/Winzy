//
//  NotificationCenterScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct NotificationCenterScreen: View {
    @State private var showNotificationSettings = false
    @State private var selectedNotification: String?
    
    let notifications = [
        "New message from John: 'Hey, let's catch up!'",
        "Missed call from Alice",
        "Group 'Family Chat' updated with a new photo",
        "You have a new friend request from Mark"
    ]
    
    var body: some View {
        ZStack {
            // Background with vibrant color gradient
//            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
            
            GradientBackgroundView()
            
            FloatingShapes()

            
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
                    Text("Notifications")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        showNotificationSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Notifications List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(notifications, id: \.self) { notification in
                            NotificationCell(notification: notification)
                                .onTapGesture {
                                    selectedNotification = notification
                                }
                        }
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
            
            // Floating Action Button to customize settings or actions
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Quick action for dismissing all notifications
                    }) {
                        Image(systemName: "trash.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        // Quick action to open notification settings
                        showNotificationSettings.toggle()
                    }) {
                        Image(systemName: "bell.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 20)
                }
            }
            
            // Notification Settings Sheet
            if showNotificationSettings {
                NotificationSettingsView()
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

struct NotificationCell: View {
    var notification: String
    
    var body: some View {
        HStack {
            Image(systemName: "bell.fill")
                .font(.title2)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(notification)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Just now")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            // Quick Action Buttons
            HStack(spacing: 15) {
                Button(action: {
                    // Action to reply to the notification
                }) {
                    Image(systemName: "message.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    // Action to open chat
                }) {
                    Image(systemName: "bubble.left.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    // Action to dismiss notification
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
            .padding(.leading)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct NotificationSettingsView: View {
    @State private var enableSound = true
    @State private var enableVibration = true
    
    var body: some View {
        VStack {
            Text("Notification Settings")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Toggle(isOn: $enableSound) {
                Text("Enable Sound")
                    .font(.headline)
            }
            .padding()
            
            Toggle(isOn: $enableVibration) {
                Text("Enable Vibration")
                    .font(.headline)
            }
            .padding()
            
            Button(action: {
                // Save settings
            }) {
                Text("Save Settings")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

struct NotificationCenterScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCenterScreen()
    }
}
