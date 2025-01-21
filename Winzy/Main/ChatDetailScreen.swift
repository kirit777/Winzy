//
//  ChatDetailScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct ChatDetailScreen: View {
//    struct Message: Identifiable {
//        let id = UUID()
//        let text: String
//        let isSentByUser: Bool
//    }
    @StateObject private var viewModel = ChatDetailViewModel()
    @StateObject private var chatManager = ChatManager()
    @State private var newMessage: String = ""
    @State private var selectedMedia: [MediaItem] = []
    @State private var isPickerPresented = false
    
    
    @State private var messages: [ChatMessage] = [
        
    ]
    @Environment(\.presentationMode) var presentationMode
    var chatId: String
    
    
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
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                    
                    Spacer()
                    
                    Text("Username")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        // More details action
                    }) {
                        Image(systemName: "ellipsis")
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
                
                // Chat Area
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }
                
                // Floating Message Input View
                HStack(spacing: 10) {
                    // Photo Button
                    Button(action: {
                        isPickerPresented.toggle()
                    }) {
                        Image(systemName: "photo")
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
                    .fullScreenCover(isPresented: $isPickerPresented, content: {
                        MediaPickerViewChat(selectedMedia: $selectedMedia)
                    })
                    
                    // Text Field
                    TextField("Type a message...", text: $newMessage)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                    
                    // Send Button
                    Button(action: {
                        if !newMessage.isEmpty {
                            viewModel.sendMessage(chatID: viewModel.generateChatID(currentUserPhone: "7043805425", otherUserPhone: "9265107070"), message: newMessage)
                            newMessage = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.green))
                            .shadow(radius: 5)
                    }
                    
                    // Mic Button
                    Button(action: {
                        // Voice recording action
                    }) {
                        Image(systemName: "mic.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.red))
                            .shadow(radius: 5)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(30)
                .shadow(radius: 10)
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchMessages(chatID: viewModel.generateChatID(currentUserPhone: "7043805425", otherUserPhone: "9265107070") )
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                Spacer()
            }
        }
    }
}

//struct ChatDetailScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatDetailScreen()
//    }
//}
