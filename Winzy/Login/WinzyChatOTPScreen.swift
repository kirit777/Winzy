//
//  WinzyChatOTPScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 30/12/24.
//

import SwiftUI
import FirebaseAuth
import Starscream
import FirebaseDatabase

struct WinzyChatOTPScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var otp: String = ""
    @State private var isSubmittingOTP = false
    @State private var errorMessage: String? = nil
    @State var isSendingOTP: Bool = false
    @State var isVerificatinDone: Bool = false
    @State var verificationID:String = ""
    @State var webSocketManager =  ChatSocketService()
    var username: String = ""
    var serverURL: String = ""
    var roomCode: String = ""
    @State private var isOTPCalled = false
    
    // Function to send OTP to the phone number
    func sendOTP() {
        isSendingOTP = true
        errorMessage = nil
        
        let phoneNumberWithCountryCode = "+917043805425" // Include country code (e.g., "+1" for US)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberWithCountryCode, uiDelegate: nil) { (verificationID, error) in
            self.isSendingOTP = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if let verificationID = verificationID {
                self.verificationID = verificationID
                print("OTP sent, verification ID: \(verificationID)")
            }
        }
    }
    
    // Function to verify OTP entered by the user
    func verifyOTP() {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.errorMessage = "Failed to verify OTP: \(error.localizedDescription)"
            } else {
                // Successfully signed in
                print("User signed in successfully!")
                if let user = authResult?.user {
                    //self.isLoggedIn = true
                   // webSocketManager.createChatIfNotExists(chatId: <#T##String#>)
                    UserDefaultsManager.shared.set(user.uid, forKey: String.loggedInUserId)
                    addUserToDatabase(contact: ContactFirebase(id: UUID().uuidString, name: username, phoneNumber: user.phoneNumber ?? "", verificationID: verificationID), completion: { _,_ in
                        isVerificatinDone = true
                    })
                    
                }
                // Navigate to the next screen or handle successful authentication
            }
        }
    }
    
    
    func addUserToDatabase(contact: ContactFirebase, completion: @escaping (Bool, String?) -> Void) {
        // Get reference to the Realtime Database
        let ref = Database.database().reference()
        
        // Check if the phone number already exists in the database
        ref.child("contacts").queryOrdered(byChild: "phoneNumber").queryEqual(toValue: contact.phoneNumber).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                // If phone number exists, don't add new entry
                completion(false, "Phone number already exists.")
            } else {
                // If phone number doesn't exist, create new entry
                let userID = contact.phoneNumber //ref.child("contacts").childByAutoId().key // Automatically generate a unique ID for the new entry
                
                // Create a dictionary with user data
                let userData: [String: Any] = [
                    "id": userID ?? "",
                    "name": contact.name,
                    "phoneNumber": contact.phoneNumber,
                    "verificationID": contact.verificationID
                ]
                
                // Set the data in the Firebase Realtime Database under the "contacts" node
                ref.child("contacts").child(userID).setValue(userData) { error, _ in
                    if let error = error {
                        completion(false, "Failed to add user: \(error.localizedDescription)")
                    } else {
                        completion(true, "User added successfully.")
                    }
                }
            }
        })
    }

    
    var body: some View {
       
            ZStack {
                // Background Gradient
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.purple, Color.blue, Color.pink]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                .edgesIgnoringSafeArea(.all)
                
                GradientBackgroundView()
                
                
                
                
                
                // Floating Bubbles
                FloatingShapes()

                
                // Main Content
                VStack(spacing: 30) {
                    // App Title
                    //                Text("Winzy Chat - OTP")
                    //                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    //                    .foregroundColor(.white)
                    //                    .shadow(radius: 10)
                    
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
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    
                    // OTP Input Fields
                    VStack(spacing: 20) {
                        OTPTextField(otp: $otp)
                    }
                    
                    Spacer()
                    // Error Message (if any)
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.top, 5)
                    }
                    
                    // Submit OTP Button
                    Button(action: {
                       // isSubmittingOTP = true
                        // Simulate OTP submission
                        verifyOTP()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            // Assume OTP validation here
//                            if otp == "123456" {
//                                // Successfully submitted OTP
//                                //isSubmittingOTP = false
//                                errorMessage = nil
//                                // Navigate to next screen
//                            } else {
//                                // OTP validation failed
//                                //isSubmittingOTP = false
//                                errorMessage = "Invalid OTP. Please try again."
//                            }
//                        }
                    }) {
                        Text(isSubmittingOTP ? "Submitting..." : "Submit OTP")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            )
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    }
                    .disabled(isSubmittingOTP)
                    .padding(.top, 20)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.0))
                        .shadow(radius: 20)
                )
                .padding()
                
                
                NavigationLink(
                    destination: CustomeTabbarView(),
                    isActive: $isVerificatinDone,
                    label: {
                        EmptyView() // Invisible view to trigger navigation
                    }
                )
                .hidden()
            }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .onAppear(){
                    if !isOTPCalled {
                        sendOTP()
                        isOTPCalled = true // Mark OTP as sent
                    }
                }
       
    }
}


struct OTPTextField: View {
    @Binding var otp: String
    
    // Separate state variables for each digit
    @State private var otp1: String = ""
    @State private var otp2: String = ""
    @State private var otp3: String = ""
    @State private var otp4: String = ""
    @State private var otp5: String = ""
    @State private var otp6: String = ""
    
    // Focus state for managing focus between text fields
    @FocusState private var focusedField: Field?
    
    // Enum to identify each field
    enum Field {
        case otp1, otp2, otp3, otp4 , otp5 , otp6
    }
    
    var body: some View {
        HStack {
            // TextField for first digit
            TextField("", text: $otp1)
                .keyboardType(.numberPad)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .font(.title)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .otp1) // Bind focus state
                .onChange(of: otp1) { newValue in
                    if newValue.count == 1 {
                        focusedField = .otp2 // Move to next field
                        updateOTP()
                    }
                }
            
            // TextField for second digit
            TextField("", text: $otp2)
                .keyboardType(.numberPad)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .font(.title)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .otp2)
                .onChange(of: otp2) { newValue in
                    if newValue.count == 1 {
                        focusedField = .otp3
                        updateOTP()
                    }
                }
            
            // TextField for third digit
            TextField("", text: $otp3)
                .keyboardType(.numberPad)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .font(.title)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .otp3)
                .onChange(of: otp3) { newValue in
                    if newValue.count == 1 {
                        focusedField = .otp4
                        updateOTP()
                    }
                }
            
            // TextField for fourth digit
            TextField("", text: $otp4)
                .keyboardType(.numberPad)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .font(.title)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .otp4)
                .onChange(of: otp4) { newValue in
                    if newValue.count == 1 {
                        focusedField = .otp5 // End editing
                        updateOTP()
                    }
                }
            
            // TextField for fourth digit
            TextField("", text: $otp5)
                .keyboardType(.numberPad)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .font(.title)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .otp5)
                .onChange(of: otp5) { newValue in
                    if newValue.count == 1 {
                        focusedField = .otp6 // End editing
                        updateOTP()
                    }
                }
            
            // TextField for fourth digit
            TextField("", text: $otp6)
                .keyboardType(.numberPad)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .font(.title)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .otp6)
                .onChange(of: otp6) { newValue in
                    if newValue.count == 1 {
                        focusedField = nil // End editing
                        updateOTP()
                    }
                }
        }
        .padding()
        .onAppear {
            focusedField = .otp1 // Automatically focus the first field on appear
        }
    }
    
    // Function to update the combined OTP
    private func updateOTP() {
        otp = otp1 + otp2 + otp3 + otp4 + otp5 + otp6
    }
}




struct OTPTextField2: View {
    @Binding var otp: String
    
    var body: some View {
        HStack {
            ForEach(0..<4, id: \.self) { index in
                TextField("", text: Binding(
                    get: {
                        otp.count > index ? String(otp[otp.index(otp.startIndex, offsetBy: index)]) : ""
                    },
                    set: { newValue in
                        let startIndex = otp.index(otp.startIndex, offsetBy: index)
                        otp.replaceSubrange(startIndex..<otp.index(startIndex, offsetBy: 1), with: newValue)
                    }
                ))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .font(.title)
            }
        }
        .padding()
    }
}

struct FloatingBubbles2: View {
    @State private var moveRight = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(index % 2 == 0 ? Color.blue.opacity(0.3) : Color.purple.opacity(0.3))
                        .frame(width: CGFloat.random(in: 30...80), height: CGFloat.random(in: 30...80))
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

struct WinzyChatOTPScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinzyChatOTPScreen()
    }
}
