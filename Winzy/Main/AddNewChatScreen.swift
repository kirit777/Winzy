//
//  AddNewChatScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI
import FirebaseAuth
import Contacts
import FirebaseDatabase

struct AddNewChatScreen: View {
    struct Contact: Identifiable {
        let id = UUID()
        let name: String
        let phoneNumber: String
        let image: UIImage // Use system name or URL
    }
    @State var chatManager:MyChatManager = MyChatManager()
    @Environment(\.presentationMode) var presentationMode
    @State private var contacts : [Contact] = [
       
    ]
    
    @State  var registeredContacts: [Contact] = []
    @State private var isFetchingContacts = false
    @State private var errorMessage: String?
    @State var webSocketManager = ChatSocketService()
    @State var isLoading:Bool = true
    func fetchRegisteredContacts(){
       // var registeredContacts: [Contact] = []
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                print("Access denied")
                return
            }
            
            let keys = [
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataKey
            ] as [CNKeyDescriptor]
            
            let request = CNContactFetchRequest(keysToFetch: keys)
            
            var fetchedContacts: [Contact] = []
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    
                    var phoneNumbers = ""
                    if let mobilePhone = contact.phoneNumbers.first(where: { $0.label == CNLabelPhoneNumberMobile }) {
                        phoneNumbers =  mobilePhone.value.stringValue
                    }
                    
                   
                    let image = contact.imageData.flatMap { UIImage(data: $0) }
                    let newContact = Contact(
                        name: contact.givenName,
                        phoneNumber: phoneNumbers,
                        image: (image ?? UIImage(named: "photo2"))!
                    )
                    self.contacts.append(newContact)
                    
                    
                }
               // print("contactInfo \(fetchedContacts)")
                DispatchQueue.main.async {
                    self.contacts = fetchedContacts
                }
            } catch {
                print("Failed to fetch contacts: \(error)")
            }
        }
        
        let group = DispatchGroup()
        for contact in contacts {
            print("contactInfo2 \(contact.phoneNumber)")
            let phoneNumber = contact.phoneNumber
            
            
            
            // Firebase check starts
            group.enter()
            
            checkAndAddPhoneNumberToArray(phoneNumber: phoneNumber, completion: {_ in 
                
            })
            
            
        }
        isLoading = false
        group.notify(queue: .main) {
           // completion(registeredContacts)
            self.isFetchingContacts = false
           
        }
    }

    
    func checkAndAddPhoneNumberToArray(phoneNumber: String, completion: @escaping ([Contact]) -> Void) {
        let ref = Database.database().reference()
        
        // Normalize the phone number by removing non-numeric characters
        let normalizedPhoneNumber = normalizePhoneNumber(phoneNumber)
        print("normalizedPhoneNumber \(normalizedPhoneNumber)")
        var contactsFound: [Contact] = []
        
        // Query Firebase Realtime Database to find users with matching phone number
        ref.child("contacts").queryOrdered(byChild: "phoneNumber").queryEqual(toValue: normalizedPhoneNumber).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                // If the phone number exists, add the full contact objects to the array
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    if let contactDict = child.value as? [String: Any] {
                        // Extract data from the snapshot
                        if let name = contactDict["name"] as? String,
                           let phoneNumber = contactDict["phoneNumber"] as? String,
                           let verificationID = contactDict["verificationID"] as? String {
                            
                            // Create a Contact object
                            let contact = Contact(name: name, phoneNumber: phoneNumber, image: UIImage(named: "photo2")!)
                            
                            // Add to the array
                            registeredContacts.append(contact)
                        }
                    }
                }
            }
            
            // Return the list of full contact objects
            completion(contactsFound)
        })
    }
    
    // Helper function to normalize phone number by removing country code and symbols
    func normalizePhoneNumber(_ phoneNumber: String) -> String {
        // Remove all non-numeric characters
        let numericSet = CharacterSet.decimalDigits
        let filteredNumber = phoneNumber.filter { numericSet.contains($0.unicodeScalars.first!) }
        
        // Handle different cases for matching
        if filteredNumber.hasPrefix("91") && filteredNumber.count > 10 {
            return String(filteredNumber.suffix(10)) // Extract the last 10 digits for India
        } else if filteredNumber.count > 10 {
            return String(filteredNumber.suffix(10)) // For other country codes, default to last 10 digits
        }
        
        return filteredNumber // Return as-is if it's already a 10-digit number
    }
    
    
    func checkFirebaseRegistration(for phoneNumbers: [String]) {
        let dispatchGroup = DispatchGroup()
        var registered: [String] = []
        
        for number in phoneNumbers {
            dispatchGroup.enter()
            
            let formattedNumber = "+1\(number)" // Add country code (adjust as needed)
            
            // Use Firebase to check if the user exists
            Auth.auth().fetchSignInMethods(forEmail: formattedNumber) { methods, error in
                if let methods = methods, !methods.isEmpty {
                    registered.append(formattedNumber)
                }
                dispatchGroup.leave()
            }
        }

//            dispatchGroup.notify(queue: .main) {
//                self.registeredContacts = registered
//                self.isFetchingContacts = false
//            }
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
                    
                    Text("Add New Chat")
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
                
                
                // Contact List
                ScrollView {
                    
                    if isLoading {
                        BigCrazyLoadingView()
                    } else if registeredContacts.count <= 0 {
                        NoContainView(state: .noContacts)
                    } else {
                        VStack(spacing: 15) {
                            ForEach(0..<registeredContacts.count , id: \.self) { index in
                                ContactRow(contact: registeredContacts[index])
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear(){
                fetchRegisteredContacts()
            }
        }
    }
    
    func ContactRow(contact: AddNewChatScreen.Contact) -> some View{
        HStack(spacing: 15) {
            // Contact Image
            Image(uiImage: contact.image)
                .resizable()
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.white))
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 5) {
                // Contact Name
                Text(contact.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                // Contact Number
                Text(contact.phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // New Chat Button
            Button(action: {
                // Action to start a new chat
                print("Start chat with \(contact.name)")
                //ContactRow
                let currentUserPhone = "7043805425"
                let otherUserPhone = "9265107070"
                chatManager.checkIfChatExists(currentUserPhone: currentUserPhone, otherUserPhone: otherUserPhone) { exists in
                    if exists {
                        chatManager.createNewChat(currentUserPhone: currentUserPhone, otherUserPhone: otherUserPhone, chatIDString: { chatIDString in
                            
                        })
                    }else{
                        chatManager.createNewChat(currentUserPhone: currentUserPhone, otherUserPhone: otherUserPhone, chatIDString: { chatIDString in
                            
                        })
                    }
                }
                if let userID = UserDefaultsManager.shared.get(forKey: String.loggedInUserId, as: String?.self) as? String {
                    
                }
            }) {
                Image(systemName: "message.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )))
                    .shadow(radius: 5)
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

//struct ContactRow: View {
//    let contact: AddNewChatScreen.Contact
//    
//    var body: some View {
//        HStack(spacing: 15) {
//            // Contact Image
//            Image(systemName: contact.image)
//                .resizable()
//                .frame(width: 50, height: 50)
//                .background(Circle().fill(Color.white))
//                .shadow(radius: 5)
//            
//            VStack(alignment: .leading, spacing: 5) {
//                // Contact Name
//                Text(contact.name)
//                    .font(.headline)
//                    .foregroundColor(.white)
//                
//                // Contact Number
//                Text(contact.phoneNumber)
//                    .font(.subheadline)
//                    .foregroundColor(.white.opacity(0.7))
//            }
//            
//            Spacer()
//            
//            // New Chat Button
//            Button(action: {
//                // Action to start a new chat
//                print("Start chat with \(contact.name)")
//                
//                webSocketManager.checkOrCreateChat(<#WebSocketManager#>)
//            }) {
//                Image(systemName: "message.fill")
//                    .font(.title2)
//                    .foregroundColor(.white)
//                    .padding(10)
//                    .background(Circle().fill(LinearGradient(
//                        gradient: Gradient(colors: [Color.blue, Color.purple]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )))
//                    .shadow(radius: 5)
//            }
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.white.opacity(0.1))
//                .shadow(radius: 10)
//        )
//        .padding(.horizontal)
//    }
//}

struct AddNewChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddNewChatScreen()
    }
}
