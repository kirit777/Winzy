//
//  FriendRequestsContactsScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct FriendRequestsContactsScreen: View {
    @State private var friendRequests = [
        FriendRequest(name: "John Doe", status: "Received", imageName: "profile_1"),
        FriendRequest(name: "Jane Smith", status: "Sent", imageName: "profile_2"),
        FriendRequest(name: "Sarah Lee", status: "Received", imageName: "profile_3")
    ]
    @State private var contacts = [
        ContactFriend(name: "Alice Brown", phoneNumber: "+123456789", imageName: "profile_4"),
        ContactFriend(name: "Michael Johnson", phoneNumber: "+987654321", imageName: "profile_5")
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
                    Text("Friend Requests & Contacts")
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
                
                // Friend Requests Section
                VStack(alignment: .leading) {
                    Text("Friend Requests")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    ScrollView {
                        ForEach(friendRequests, id: \.name) { request in
                            FriendRequestView(request: request)
                        }
                    }
                }
                .padding(.top, 10)
                
                // Contacts Section
                VStack(alignment: .leading) {
                    Text("Your Contacts")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    ScrollView {
                        ForEach(contacts, id: \.name) { contact in
                            ContactView(contact: contact)
                        }
                    }
                    
                    // Button to import contacts
                    Button(action: {
                        // Import contacts from phonebook
                    }) {
                        Text("Import Contacts from Phonebook")
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.top, 20)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            
            // Floating action button for importing contacts
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Import contacts from phonebook
                    }) {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
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
        }
    }
}

struct FriendRequest: Identifiable {
    var id = UUID()
    var name: String
    var status: String
    var imageName: String
}

struct ContactFriend: Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    var imageName: String
}

struct FriendRequestView: View {
    var request: FriendRequest
    
    var body: some View {
        HStack {
            Image(request.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(5)
            
            VStack(alignment: .leading) {
                Text(request.name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(request.status)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if request.status == "Received" {
                HStack {
                    Button(action: {
                        // Accept Friend Request
                    }) {
                        Text("Accept")
                            .padding(10)
                            .background(Color.green)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                    }
                    Button(action: {
                        // Decline Friend Request
                    }) {
                        Text("Decline")
                            .padding(10)
                            .background(Color.red)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                    }
                }
            } else {
                Text("Pending...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct ContactView: View {
    var contact: ContactFriend
    
    var body: some View {
        HStack {
            Image(contact.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(5)
            
            VStack(alignment: .leading) {
                Text(contact.name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(contact.phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                // Start new chat with contact
            }) {
                Image(systemName: "message.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct FriendRequestsContactsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsContactsScreen()
    }
}
