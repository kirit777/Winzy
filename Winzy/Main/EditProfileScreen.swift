//
//  EditProfileScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct EditProfileScreen: View {
    @State private var userName: String = "John Doe"
    @State private var phoneNumber: String = "+1 234 567 8901"
    @State private var bio: String = "iOS Developer, Coffee Lover ☕, Explorer 🌍"
    @State private var profileImage: String = "person.circle.fill"
    
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
                // Navigation Bar
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
                    
                    Text("Edit Profile")
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
                
                // Profile Image Section
                VStack {
                    ZStack {
                        Image(systemName: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                            .clipShape(Circle())
                            .shadow(radius: 10)
                        
                        Button(action: {
                            // Edit image action
                        }) {
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Circle().fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )))
                                .shadow(radius: 5)
                        }
                        .offset(x: 35, y: 40)
                    }
                }
                .padding(.bottom, 20)
                
                // Editable Fields
                VStack(spacing: 20) {
                    EditableField(
                        placeholder: "Name",
                        text: $userName,
                        iconName: "person.fill"
                    )
                    
                    EditableField(
                        placeholder: "Phone Number",
                        text: $phoneNumber,
                        iconName: "phone.fill"
                    )
                    
                    EditableField(
                        placeholder: "Bio",
                        text: $bio,
                        iconName: "text.bubble.fill"
                    )
                }
                .padding(.horizontal)
                
                // Update Button
                Button(action: {
                    // Update action
                    print("Profile updated!")
                }) {
                    Text("Update")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                Spacer()
            }
        }
    }
}

struct EditableField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .padding(10)
                .background(Circle().fill(Color.white.opacity(0.2)))
                .shadow(radius: 5)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(Color.white.opacity(0.1)))
        .shadow(radius: 10)
    }
}

struct EditProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileScreen()
    }
}
