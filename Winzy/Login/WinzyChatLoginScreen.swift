//
//  WinzyChatLoginScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct WinzyChatLoginScreen: View {
    @State private var username: String = ""
    @State private var serverURL: String = ""
    @State private var roomCode: String = ""
    @State private var isLoggingIn = false
    @State private var isBtnLoginClick = false
    @State private var selectedCountryCode: String = "+91"
    @State private var showCountryCodeList = false
    
    let countryCodes = [
        "+86 - China", "+91 - India", "+1 - United States", "+62 - Indonesia", "+92 - Pakistan",
        "+55 - Brazil", "+234 - Nigeria", "+880 - Bangladesh", "+7 - Russia", "+52 - Mexico",
        "+352 - Luxembourg", "+41 - Switzerland", "+353 - Ireland", "+47 - Norway", "+974 - Qatar",
        "+354 - Iceland", "+45 - Denmark", "+65 - Singapore", "+61 - Australia"
    ]
    
    var body: some View {
       
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue, Color.pink]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                // Floating Bubbles
                FloatingShapes()
                
                // Main Content
                VStack(spacing: 30) {
                    // App Title
                    Text("Winzy Chat")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                    
                    // Text Fields
                    
                    GeometryReader { geometry in
                        
                        VStack(spacing: 20) {
                            CrazyTextField(placeholder: "Username", text: $username, icon: "person.fill",showCountryCodeList: $showCountryCodeList,selectedCountryCode: $selectedCountryCode)
                            CrazyTextField(placeholder: "Mobile Number", text: $serverURL, icon: "server.rack",showCountryCodeList: $showCountryCodeList,selectedCountryCode: $selectedCountryCode)
                            CrazyTextField(placeholder: "Referral Code (Optional)", text: $roomCode, icon: "key.fill",showCountryCodeList: $showCountryCodeList,selectedCountryCode: $selectedCountryCode)
                        }
                        
                        .sheet(isPresented: $showCountryCodeList) {
                            VStack {
                                Text("Select a Country Code")
                                    .font(.headline)
                                    .padding()
                                
                                List(countryCodes, id: \.self) { code in
                                    HStack{
                                        Text(code)
                                            .padding()
                                            .frame(width:geometry.size.width * 0.9,alignment:.leading)
                                            .background(.white)
                                            .multilineTextAlignment(.leading)
                                            .onTapGesture {
                                                // When a country code is selected
                                                self.selectedCountryCode = code.split(separator: " ")[0].description // Extract country code
                                                //self.phoneNumber = self.selectedCountryCode + " " + self.phoneNumber
                                                self.showCountryCodeList = false  // Close the sheet
                                            }
                                    }
                                }
                            }
                            .presentationDetents([.medium, .large])
                        }
                    }
                    
                   
                    
                    // Login Button
                    Button(action: {
                        isBtnLoginClick = true
                        isLoggingIn = true
                        // Add your login action here
                    }) {
                        Text(isLoggingIn ? "Connecting..." : "Login")
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
                    .disabled(isLoggingIn)
                    .padding(.top, 20)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.9))
                        .shadow(radius: 20)
                )
                .padding()
                
                NavigationLink(
                    destination: WinzyChatOTPScreen(username: username,serverURL: "\(selectedCountryCode)\(serverURL)", roomCode: roomCode),
                    isActive: $isBtnLoginClick,
                    label: {
                        EmptyView() // Invisible view to trigger navigation
                    }
                )
                .hidden()
                
            }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        
    }
}

struct CrazyTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String
    @Binding  var showCountryCodeList:Bool
    @Binding  var selectedCountryCode: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.purple)
            
            if placeholder == "Mobile Number" {
                Button(action: {
                    // Toggle the country code list
                    showCountryCodeList.toggle()
                }) {
                    Text(selectedCountryCode)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(.black)
                        .cornerRadius(8)
                        .minimumScaleFactor(0.5)
                        .frame(width: 60, height: 50)
                }
            }
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.leading, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}



struct WinzyChatLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinzyChatLoginScreen()
    }
}
