
import FirebaseDatabase

class ChatManager {
    
    static let shared = ChatManager()  // Singleton instance
    
     init() {}  // Private initializer to prevent instantiation
    
     let chatListRef = Database.database().reference().child("ChatList")
     let messageListRef = Database.database().reference().child("MessageList")
    
    /// Generates a unique chat ID for two users (order-independent).
    func generateChatId(myNumber: String, otherUserNumber: String) -> String {
        let numbers = [myNumber, otherUserNumber].sorted()
        return "\(numbers[0])_\(numbers[1])"
    }
    
    /// Checks if a chat already exists between two users.
    func checkIfChatExists(with userNumber: String, myNumber: String, completion: @escaping (String?) -> Void) {
        let chatId = generateChatId(myNumber: myNumber, otherUserNumber: userNumber)
        
        chatListRef.child(chatId).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(chatId)  // Chat exists, return the chat ID
            } else {
                completion(nil)  // No chat found
            }
        }
    }
    
    /// Creates a new chat between two users.
    func createNewChat(with userNumber: String, userName: String, myNumber: String, myName: String, completion: @escaping (String) -> Void) {
        let chatId = generateChatId(myNumber: myNumber, otherUserNumber: userNumber)
        
        let chatData: [String: Any] = [
            "ChatId": chatId,
            "User1Number": myNumber,
            "User2Number": userNumber,
            "User1Name": myName,
            "User2Name": userName
        ]
        
        chatListRef.child(chatId).setValue(chatData) { error, _ in
            if error == nil {
                completion(chatId)  // Chat created, return chat ID
            } else {
                print("Failed to create chat: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    /// Fetches all messages for a given chat ID.
    func fetchMessages(for chatId: String, completion: @escaping ([Message]) -> Void) {
        messageListRef.child(chatId).observe(.value) { snapshot in
            var messages: [Message] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let data = childSnapshot.value as? [String: Any],
                   let messageId = data["MessageId"] as? String,
                   let isSendBy = data["isSendBy"] as? String,
                   let content = data["MessageContent"] as? String,
                   let timeStamp = data["TimeStamp"] as? Double {
                    let message = Message(
                        messageId: messageId,
                        isSendBy: isSendBy,
                        content: content,
                        timeStamp: timeStamp
                    )
                    messages.append(message)
                }
            }
            completion(messages)
        }
    }
    
    /// Sends a new message in a chat.
    func sendMessage(chatId: String, messageId: String, isSendBy: String, content: String, timeStamp: Double, completion: @escaping (Bool) -> Void) {
        let messageData: [String: Any] = [
            "MessageId": messageId,
            "isSendBy": isSendBy,
            "MessageContent": content,
            "TimeStamp": timeStamp
        ]
        
        messageListRef.child(chatId).child(messageId).setValue(messageData) { error, _ in
            if error == nil {
                completion(true)  // Message sent successfully
            } else {
                print("Failed to send message: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
    
    
    func findExistingChat(userA: String, userB: String, completion: @escaping (Chat?) -> Void) {
        let databaseRef = Database.database().reference()
        
        // Creating the chat key by combining the two users' phone numbers
        let chatKey = userA < userB ? "\(userA)_\(userB)" : "\(userB)_\(userA)"
        
        // Check if the chat already exists in the Firebase database
        databaseRef.child("chats").child(chatKey).observeSingleEvent(of: .value) { snapshot in
            if let chatData = snapshot.value as? [String: Any] {
                // If the chat exists, return the chat data
                let chat = Chat(chatId: chatKey, user1Id: chatData["user1_id"] as? String, user2Id: chatData["user2_id"] as? String)
                completion(chat)
            } else {
                // If the chat doesn't exist, return nil
                completion(nil)
            }
        }
    }
}

struct Chat {
    var chatId: String
    var user1Id: String?
    var user2Id: String?
}

struct Message : Identifiable {
    var id: UUID = UUID()
    let messageId: String
    let isSendBy: String
    let content: String
    let timeStamp: Double
}
