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

struct ChatUser: Identifiable {
    let id = UUID()
    var chatID: String?
    let name: String
    let number:String
    let lastMessage: String
    let unreadCount: Int
    let lastMessageTime: String
    let image: String // Use system name or URL
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



//struct ChatMessage: Codable, Identifiable {
//    let id: UUID
//    let sender: String
//    let content: String
//    let timestamp: Date
//}



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


enum UserDefaultsKeys: String {
    case userName = "userName"
    case isLoggedIn = "isLoggedIn"
    case userPhone = "userPhone"
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
//struct Chat {
//    let chatId: String
//    let userA: String
//    let userB: String
//    var messages: [Message]
//}

//struct ChatMessage : Codable,Identifiable {
//    let id: UUID
//    let sender: String
//    let content: String
//    let timestamp: Date
//    
//    // Replace "currentUser" with the actual user's identifier
//    var isFromCurrentUser: Bool {
//        return sender == "currentUser"
//    }
//}


