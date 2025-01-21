//
//  Custom.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 31/12/24.
//
import SwiftUI
import Starscream
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct ContactFirebase: Identifiable {
    let id: String
    let name: String
    let phoneNumber: String
    let verificationID: String
}


struct ChatResponse: Codable {
    var chatID: String?
    var phoneNumber: String
    var userID: String
}

struct MessageFire: Identifiable {
    var id: String // Unique identifier for the message
    var sender: String // Sender's phone number or ID
    var message: String // The actual message text
    var timestamp: Double // Timestamp of when the message was sent
}

class ChatDetailViewModel: ObservableObject {
    @Published var messages: [MessageFire] = []
    var ref: DatabaseReference! = Database.database().reference()
    
    func generateChatID(currentUserPhone: String, otherUserPhone: String) -> String {
        // Sort the two phone numbers to ensure consistency in order
        let sortedPhones = [currentUserPhone, otherUserPhone].sorted()
        
        // Combine the sorted phone numbers into a unique chat ID
        return "\(sortedPhones[0])_\(sortedPhones[1])"
    }
    
    func fetchMessages(chatID: String) {
        ref.child("chats").child(chatID).child("messages").observe(.value) { snapshot in
            var loadedMessages: [MessageFire] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let messageData = snapshot.value as? [String: Any],
                   let sender = messageData["sender"] as? String,
                   let message = messageData["message"] as? String {
                    let message = MessageFire(id: snapshot.key, sender: sender, message: message, timestamp: 19.74)
                    loadedMessages.append(message)
                }
            }
            self.messages = loadedMessages
            print(self.messages)
        }
    }
    
    func sendMessage(chatID:String,message:String) {
        let newMessageData: [String: Any] = [
            "sender": "current_user_phone_number", // Replace with current user's phone number
            "message": message
        ]
        
        let messageID = ref.child("chats").child(chatID).child("messages").childByAutoId().key
        ref.child("chats").child(chatID).child("messages").child(messageID!).setValue(newMessageData)
    }
    
}


class MyChatManager: ObservableObject {
    var ref: DatabaseReference! = Database.database().reference()
    
    // Check if the chat already exists between the current user and the other user
    func checkIfChatExists(currentUserPhone: String, otherUserPhone: String, completion: @escaping (Bool) -> Void) {
        let chatID = generateChatID(currentUserPhone: currentUserPhone, otherUserPhone: otherUserPhone)
        
        ref.child("chats").child(chatID).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                // Chat already exists
                completion(true)
            } else {
                // Chat doesn't exist
                completion(false)
            }
        })
    }
    
    // Create a unique chat ID using the user phone numbers
    func generateChatID(currentUserPhone: String, otherUserPhone: String) -> String {
        // Sort the two phone numbers to ensure consistency in order
        let sortedPhones = [currentUserPhone, otherUserPhone].sorted()
        
        // Combine the sorted phone numbers into a unique chat ID
        return "\(sortedPhones[0])_\(sortedPhones[1])"
    }
    
    // Create a new chat between the users
    func createNewChat(currentUserPhone: String, otherUserPhone: String,chatIDString: @escaping (String) -> Void) {
        let chatID = generateChatID(currentUserPhone: currentUserPhone, otherUserPhone: otherUserPhone)
        
        // Create a new chat entry in Firebase
        let chatData: [String: Any] = [
            "user1_id": currentUserPhone,
            "user2_id": otherUserPhone
        ]
        
        ref.child("chats").child(chatID).setValue(chatData)
        chatIDString(chatID)
    }
}


//struct ChatMessage: Codable, Identifiable {
//    let id: UUID
//    let sender: String
//    let content: String
//    let timestamp: Date
//}

class ChatSocketService: WebSocketDelegate {
    
    
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        
    }
    
    static let shared = ChatSocketService()
     var socket: WebSocket?
     var socketIsConnected: Bool = false
     var serverURL: URL {
        URL(string: "wss://ap2.pusher.com/app/1917423?protocol=7&client=js&version=4.3.1&flash=false")!
    }

    private var messages: [String: [ChatMessage]] = [:] // Stores messages by chatId

    // MARK: - WebSocket Initialization

    init() {
        var request = URLRequest(url: serverURL)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
    }

    func connect() {
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }

    func generateChatId(for firstNumber: String, and secondNumber: String) -> String {
        let sortedNumbers = [firstNumber, secondNumber].sorted()
        return "chat_\(sortedNumbers[0])_\(sortedNumbers[1])"
    }
    // MARK: - Chat Handling

    /// Creates or opens a chat between two users using chatId
    func createChatIfNotExists(chatId: String) {
        if messages[chatId] == nil {
            messages[chatId] = []
            print("Chat created with ID: \(chatId)")
        } else {
            print("Chat already exists for ID: \(chatId)")
        }
    }

    /// Fetch all messages for a given chatId
    func fetchMessages(for chatId: String) -> [ChatMessage] {
        return messages[chatId] ?? []
    }

    /// Send a message to a specific chatId
    func sendMessage(_ message: ChatMessage, to chatId: String) {
        guard socketIsConnected == true else {
            print("Socket is not connected. Connect before sending messages.")
            return
        }
        do {
            let messageData = try JSONEncoder().encode(message)
            if var existingMessages = messages[chatId] {
                existingMessages.append(message)
                messages[chatId] = existingMessages
            } else {
                messages[chatId] = [message]
            }
            socket?.write(string: String(data: messageData, encoding: .utf8)!)
            print("Message sent to chat ID: \(chatId)")
        } catch {
            print("Failed to encode message: \(error)")
        }
    }

    // MARK: - WebSocketDelegate Methods

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(_):
            socketIsConnected = true
            print("Socket connected")
        case .disconnected(let reason, let code):
            print("Socket disconnected: \(reason) with code: \(code)")
        case .text(let text):
            print("Received message: \(text)")
            if let data = text.data(using: .utf8),
               let chatMessage = try? JSONDecoder().decode(ChatMessage.self, from: data) {
                addMessage(chatMessage, to: "example_chat_id") // Example usage
            }
        case .error(let error):
            print("Socket error: \(String(describing: error))")
        default:
            break
        }
    }

    // Helper to add messages internally
    private func addMessage(_ message: ChatMessage, to chatId: String) {
        if var existingMessages = messages[chatId] {
            existingMessages.append(message)
            messages[chatId] = existingMessages
        } else {
            messages[chatId] = [message]
        }
    }
}




struct MoreOptionsView: View {
    @Binding var showMenu:Bool
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Spacer()
            // Menu Animation
            if showMenu {
                VStack(spacing: 10) {
                    Button("Profile Settings") {
                        print("Profile Settings tapped")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    Button("Theme Settings") {
                        print("Theme Settings tapped")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    Button("Other Settings") {
                        print("Other Settings tapped")
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    Button("Close Menu") {
                        withAnimation(.spring()) {
                            self.showMenu = false
                        }
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                }
                .transition(.move(edge: .bottom))  // Smooth slide-in effect
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}


struct GradientBackgroundView: View {
    let selectedTheme:Int = 5
    var body: some View {
        switch selectedTheme{
        case 0:
            // Gradient 1: Purple to Blue to Pink
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue, Color.pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 1:
            // Gradient 2: Red to Yellow to Orange
            LinearGradient(
                gradient: Gradient(colors: [Color.red, Color.yellow, Color.orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 2:
            // Gradient 3: Green to Blue to Aqua
            LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.blue, Color.cyan]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 3:
            // Gradient 4: Pink to Orange to Yellow
            LinearGradient(
                gradient: Gradient(colors: [Color.pink, Color.orange, Color.yellow]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 4:
            // Gradient 5: Teal to Purple to Blue
            LinearGradient(
                gradient: Gradient(colors: [Color.teal, Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 5:
            // Gradient 6: Indigo to Violet to Pink
            LinearGradient(
                gradient: Gradient(colors: [Color.indigo, Color.purple, Color.pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 6:
            // Gradient 7: Blue to Green to Yellow
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.green, Color.yellow]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 7:
            // Gradient 8: Black to Gray to White
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray, Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 8:
            // Gradient 9: Brown to Tan to Beige
            LinearGradient(
                gradient: Gradient(colors: [Color.brown, Color.gray, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
        case 9:
            // Gradient 10: Gold to Orange to Red
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.orange, Color.red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)
            
        default:
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue, Color.pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct FloatingShapes: View {
    @State private var moveRight = false
    
    // List of themes with different shapes, colors, and animations
    var themes: [[ShapeConfig]] = [
        // Theme 1: Blue Circles
        [
            ShapeConfig(shape: AnyShape(Circle()), color: Color.blue.opacity(0.3), minSize: 30, maxSize: 80, moveX: true, moveY: true)
        ],
        // Theme 2: Purple Circles
        [
            ShapeConfig(shape: AnyShape(Circle()), color: Color.purple.opacity(0.3), minSize: 40, maxSize: 100, moveX: true, moveY: true)
        ],
        // Theme 3: Circles and Rectangles
        [
            ShapeConfig(shape: AnyShape(Circle()), color: Color.red.opacity(0.4), minSize: 30, maxSize: 70, moveX: true, moveY: false),
            ShapeConfig(shape: AnyShape(Rectangle()), color: Color.green.opacity(0.4), minSize: 40, maxSize: 90, moveX: true, moveY: true)
        ],
        // Theme 4: Large Colorful Bubbles
        [
            ShapeConfig(shape: AnyShape(Circle()), color: Color.blue.opacity(0.6), minSize: 60, maxSize: 120, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Circle()), color: Color.pink.opacity(0.6), minSize: 50, maxSize: 110, moveX: true, moveY: true)
        ],
        // Theme 5: Ellipses and Rectangles
        [
            ShapeConfig(shape: AnyShape(Ellipse()), color: Color.orange.opacity(0.5), minSize: 40, maxSize: 80, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Rectangle()), color: Color.yellow.opacity(0.5), minSize: 30, maxSize: 60, moveX: true, moveY: true)
        ],
        // Theme 6: Large Rectangles with Random Colors
        [
            ShapeConfig(shape: AnyShape(Rectangle()), color: Color.blue.opacity(0.2), minSize: 80, maxSize: 160, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Rectangle()), color: Color.green.opacity(0.3), minSize: 70, maxSize: 140, moveX: true, moveY: true)
        ],
        // Theme 7: Small Colorful Circles
        [
            ShapeConfig(shape: AnyShape(Circle()), color: Color.green.opacity(0.4), minSize: 20, maxSize: 40, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Circle()), color: Color.orange.opacity(0.4), minSize: 25, maxSize: 45, moveX: true, moveY: true)
        ],
        // Theme 8: Circles, Ellipses, and Rectangles
        [
            ShapeConfig(shape: AnyShape(Circle()), color: Color.purple.opacity(0.5), minSize: 30, maxSize: 60, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Ellipse()), color: Color.blue.opacity(0.4), minSize: 40, maxSize: 90, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Rectangle()), color: Color.red.opacity(0.5), minSize: 50, maxSize: 100, moveX: true, moveY: true)
        ],
        // Theme 9: Neon Glow Effect
        [
            ShapeConfig(shape: AnyShape(Circle()), color: Color.cyan.opacity(0.7), minSize: 30, maxSize: 70, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Ellipse()), color: Color.yellow.opacity(0.7), minSize: 60, maxSize: 120, moveX: true, moveY: true)
        ],
        // Theme 10: Random Bright Shapes
        [
            ShapeConfig(shape: AnyShape(Circle()), color: Color.green.opacity(0.6), minSize: 50, maxSize: 100, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Rectangle()), color: Color.red.opacity(0.6), minSize: 40, maxSize: 90, moveX: true, moveY: true),
            ShapeConfig(shape: AnyShape(Ellipse()), color: Color.purple.opacity(0.6), minSize: 60, maxSize: 110, moveX: true, moveY: true)
        ]
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(themes.randomElement() ?? themes[0], id: \.id) { shapeConfig in
                    shapeConfig.shape
                        .fill(shapeConfig.color)
                        .frame(width: CGFloat.random(in: shapeConfig.minSize...shapeConfig.maxSize), height: CGFloat.random(in: shapeConfig.minSize...shapeConfig.maxSize))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .offset(x: moveRight ? 50 : -50, y: moveRight ? -50 : 50)
                        .animation(
                            Animation.linear(duration: Double.random(in: 5...10))
                                .repeatForever(autoreverses: true)
                        )
                        .onAppear {
                            moveRight.toggle()
                        }
                }
            }
        }
        .ignoresSafeArea()
    }
}

//userDefault part
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard

    private init() {}

    // Save a value to UserDefaults
    func set<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            defaults.set(encoded, forKey: key)
        } else {
            print("Failed to encode value for key \(key)")
        }
    }

    // Retrieve a value from UserDefaults
    func get<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        if let decoded = try? JSONDecoder().decode(type, from: data) {
            return decoded
        } else {
            print("Failed to decode value for key \(key)")
            return nil
        }
    }

    // Remove a value from UserDefaults
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    // Check if a key exists in UserDefaults
    func contains(key: String) -> Bool {
        defaults.object(forKey: key) != nil
    }
}


struct ShapeConfig: Identifiable {
    let id = UUID()
    var shape: AnyShape
    var color: Color
    var minSize: CGFloat
    var maxSize: CGFloat
    var moveX: Bool
    var moveY: Bool
}


struct NoContainView: View {
    enum ContactState {
        case noPermission
        case noContacts
    }
    
    let state: ContactState
    
    var body: some View {
        VStack(spacing: 20) {
            // Icon based on state
            Image(systemName: state == .noPermission ? "lock.shield" : "person.crop.circle.badge.exclamationmark")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            // Text based on state
            Text(state == .noPermission ? "Access Denied" : "No Contacts Found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(state == .noPermission
                 ? "Please enable contact access in your settings to find registered contacts."
                 : "You don't have any contacts saved on your device.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding()
    }
}


//loadingView
struct BigCrazyLoadingView: View {
    @State  var isAnimating = true
    @State  var textOffset = -20.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 20) {
                    ForEach(0..<5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple.opacity(0.8), .blue.opacity(0.6)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                            .opacity(0.7)
                            .mask(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.3))
                                    
                            )
                            .offset(y: isAnimating ? -20 : 20)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.15),
                                value: isAnimating
                            )
                    }
                }
                .onAppear {
                    isAnimating = true
                }
                .onDisappear {
                    isAnimating = false
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        
    }
}

//detail chat
struct Chat {
    let chatId: String
    let userA: String
    let userB: String
    var messages: [ChatMessage]
}

struct ChatMessage : Codable,Identifiable {
    let id: UUID
    let sender: String
    let content: String
    let timestamp: Date
    
    // Replace "currentUser" with the actual user's identifier
    var isFromCurrentUser: Bool {
        return sender == "currentUser"
    }
}

class DatabaseService {
    private static var chats: [String: Chat] = [:]
    static var webSocketManager: ChatSocketService?
    
    static func fetchChat(by chatId: String, completion: @escaping (Chat?) -> Void) {
        let chat = chats[chatId]
        completion(chat)
    }
    
    static func saveChat(_ chat: Chat) {
        // Save the chat to the database (in-memory for now)
        chats[chat.chatId] = chat
        
        // Create a WebSocket connection for this chatId
        let serverUrl = URL(string: "wss://ap2.pusher.com/app/1917423?protocol=7&client=js&version=4.3.1&flash=false")!
        webSocketManager = ChatSocketService()
        webSocketManager?.connect()
        
        webSocketManager?.createChatIfNotExists(chatId: chat.chatId)
    }
    
    static func fetchMessages(for chatId: String, completion: @escaping ([ChatMessage]) -> Void) {
        guard let chat = chats[chatId] else {
            completion([]) // No messages found for this chat
            return
        }
        completion(chat.messages)
    }
    
    static func addMessage(_ message: ChatMessage, to chatId: String) {
        guard var chat = chats[chatId] else { return }
        chat.messages.append(message)
        chats[chatId] = chat
        
        // Send the message via WebSocket
        webSocketManager?.sendMessage(message, to: chatId)
    }
}





class ChatManager: ObservableObject {
    @Published var currentChat: Chat?
    @Published var messages: [ChatMessage] = []
    
    // Fetch chat and messages
    func openChat(with chatId: String) {
        DatabaseService.fetchChat(by: chatId) { [weak self] chat in
            if let chat = chat {
                self?.currentChat = chat
                self?.fetchMessages(for: chatId)
            }
        }
    }
    
    // Fetch messages for the chat
    func fetchMessages(for chatId: String) {
        DatabaseService.fetchMessages(for: chatId) { [weak self] messages in
            DispatchQueue.main.async {
                self?.messages = messages
                print(messages)
            }
        }
    }
    
    // Add a new message to the chat
    func sendMessage(_ message: ChatMessage) {
        guard let chatId = currentChat?.chatId else { return }
        DatabaseService.addMessage(message, to: chatId)
        fetchMessages(for: chatId)  // Refresh the messages after sending
    }
}


func findExistingChat(userA: String, userB: String, completion: @escaping (Chat?) -> Void) {
    let chatId = generateChatId(userA: userA, userB: userB)
    
    // Simulate a database or server query to check chat existence
    DatabaseService.fetchChat(by: chatId) { chat in
        if let chat = chat {
            completion(chat) // Chat found
        } else {
            completion(nil)  // No chat found
        }
    }
}

func generateChatId(userA: String, userB: String) -> String {
    return [userA, userB].sorted().joined(separator: "-") // Ensure unique ID regardless of order
}

func createNewChat(userA: String, userB: String) -> Chat {
    let newChatId = generateChatId(userA: userA, userB: userB)
    let newChat = Chat(chatId: newChatId, userA: userA, userB: userB, messages: [])
    
    DatabaseService.saveChat(newChat)
    return newChat
}
