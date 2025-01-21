//
//  PrivacySettingsScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct PrivacySettingsScreen: View {
    @State private var lastSeenVisibility: String = "Everyone"
    @State private var statusVisibility: String = "Everyone"
    @State private var profilePicVisibility: String = "Everyone"
    @State private var groupAdditionControl: String = "Everyone"
    @State private var twoStepAuthenticationEnabled: Bool = false
    @State private var blockedUsers = [
        BlockedUser(name: "John Doe", imageName: "profile_1"),
        BlockedUser(name: "Jane Smith", imageName: "profile_2")
    ]
    
    var body: some View {
        ZStack {
            // Background with gradient theme
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
                    Text("Privacy Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        // More options
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Privacy Settings Sections
                VStack(alignment: .leading) {
                    // Last Seen Visibility
                    PrivacyOptionView(title: "Who can see your Last Seen?", currentValue: $lastSeenVisibility)
                    
                    // Status Visibility
                    PrivacyOptionView(title: "Who can see your Status?", currentValue: $statusVisibility)
                    
                    // Profile Picture Visibility
                    PrivacyOptionView(title: "Who can see your Profile Picture?", currentValue: $profilePicVisibility)
                    
                    // Group Addition Control
                    PrivacyOptionView(title: "Who can add you to Groups?", currentValue: $groupAdditionControl)
                    
                    // Two-Step Authentication
                    HStack {
                        Text("Enable Two-Step Authentication")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        Toggle(isOn: $twoStepAuthenticationEnabled) {
                            Text(twoStepAuthenticationEnabled ? "Enabled" : "Disabled")
                                .foregroundColor(.white)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .frame(width: 70)
                    }
                    .padding()
                    
                    // Blocked Users Section
                    VStack(alignment: .leading) {
                        Text("Blocked Users")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        ScrollView {
                            ForEach(blockedUsers, id: \.name) { user in
                                BlockedUserView(user: user)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
                .padding()
            }
            
            // Floating action button for blocked users
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Manage blocked users
                    }) {
                        Image(systemName: "person.crop.circle.badge.minus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct PrivacyOptionView: View {
    var title: String
    @Binding var currentValue: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 20)
            
            HStack {
                Text(currentValue)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(10)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    // Show options for selecting visibility
                    showOptionPicker()
                }) {
                    Text("Change")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    func showOptionPicker() {
        // Logic for changing the current visibility settings (could use a modal or action sheet)
    }
}

struct BlockedUserView: View {
    var user: BlockedUser
    
    var body: some View {
        HStack {
            Image(user.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(5)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                // Unblock user action
            }) {
                Text("Unblock")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct BlockedUser: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
}

struct PrivacySettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsScreen()
    }
}
