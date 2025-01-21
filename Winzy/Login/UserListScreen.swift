//
//  UserListScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct UserListScreen: View {
    struct ChatUser: Identifiable {
        let id = UUID()
        let name: String
        let lastMessage: String
        let unreadCount: Int
        let lastMessageTime: String
        let image: String // Use system name or URL
    }
    
    @State private var chatUsers = [
        ChatUser(name: "John Doe", lastMessage: "Hey, what's up?", unreadCount: 3, lastMessageTime: "2:15 PM", image: "person.crop.circle"),
        ChatUser(name: "Jane Smith", lastMessage: "Let's catch up soon!", unreadCount: 0, lastMessageTime: "1:45 PM", image: "person.crop.circle.fill"),
        ChatUser(name: "Alex Johnson", lastMessage: "Got it, thanks!", unreadCount: 5, lastMessageTime: "12:30 PM", image: "person.crop.circle.badge.plus"),
    ]
    @State var isDetailViewActive : Bool = false
    @State var isAddNewChatPresent : Bool = false
    @State var showMenu = false
    @State var currentChatID:String = ""
    
    func checkChat(numberOtherUser:String){
        let currentUserNumer = "9265107070"
        findExistingChat(userA: currentUserNumer, userB: numberOtherUser) { existingChat in
            if let chat = existingChat {
                print("Opening existing chat with ID: \(chat.chatId)")
                //openChatWindow(chatId: chat.chatId)
                isDetailViewActive = true
            } else {
                let newChat = createNewChat(userA: currentUserNumer, userB: numberOtherUser)
                print("Created new chat with ID: \(newChat.chatId)")
               // openChatWindow(chatId: newChat.chatId)
                isDetailViewActive = true
            }
        }
    }
    
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
            
            // Floating Bubbles
            FloatingShapes()

            
            VStack {
                
                // Navigation Bar
                HStack {
                    
                    Text("Winzy Chat")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                    
                    Spacer()
                    
                    Button(action: {
                        //showMenu = true
                    }) {
                        Image(systemName: "ellipsis.circle.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                
                
                
                
                // User List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(chatUsers) { user in
                            Button(action: {
//                                isDetailViewActive = true
                                checkChat(numberOtherUser: "7043805425")
                            }) {
                                UserRow(chatUser: user)
                            }.buttonStyle(.plain)
                                .fullScreenCover(isPresented: $isDetailViewActive, content: {
                                    ChatDetailScreen(chatId: currentChatID)
                                })
                        }
                    }
                    .padding()
                }
//                NavigationLink("", destination: ChatDetailScreen(isDetailViewActive: $isDetailViewActive), isActive: $isDetailViewActive)
//                                    .hidden()
            }
            
            Button(action: {
                isAddNewChatPresent = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24)) // Set the icon size
                    .foregroundColor(.white) // Set the icon color
                    .frame(width: 50, height: 50) // Set the button size
                    .background(Color.blue) // Set the background color
                    .clipShape(Circle()) // Make the shape round
                    .overlay(Circle().stroke(Color.white, lineWidth: 2)) // Optional: add a border
                    .shadow(radius: 10) // Optional: add a shadow effect
            }
            .position(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 200)
            .fullScreenCover(isPresented: $isAddNewChatPresent, content: {
                AddNewChatScreen()
            })
           // MoreOptionsView(showMenu: $showMenu)
        }
    }
}

struct UserRow: View {
    let chatUser: UserListScreen.ChatUser
    
    var body: some View {
        HStack(spacing: 15) {
            // User Image
            Image(systemName: chatUser.image)
                .resizable()
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.white))
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 5) {
                // User Name
                Text(chatUser.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                // Last Message
                Text(chatUser.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                // Last Message Time
                Text(chatUser.lastMessageTime)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                // Unread Message Count
                if chatUser.unreadCount > 0 {
                    Text("\(chatUser.unreadCount)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.red))
                        .shadow(radius: 5)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .shadow(radius: 10)
        )
        .padding(.horizontal)
    }
}

struct UserListScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserListScreen()
    }
}
