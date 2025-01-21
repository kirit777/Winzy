//
//  CallHistoryScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct CallHistoryScreen: View {
    struct Call: Identifiable {
        let id = UUID()
        let imageName: String
        let userName: String
        let time: String
        let callType: CallType
    }
    
    enum CallType {
        case outgoing, incoming, missed
        
        var iconName: String {
            switch self {
            case .outgoing: return "phone.arrow.up.right"
            case .incoming: return "phone.arrow.down.left"
            case .missed: return "phone.slash.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .outgoing: return .green
            case .incoming: return .blue
            case .missed: return .red
            }
        }
    }
    
    @State private var callHistory: [Call] = [
        Call(imageName: "person.crop.circle.fill", userName: "John Doe", time: "2 hrs ago", callType: .incoming),
        Call(imageName: "person.crop.circle.badge.plus", userName: "Jane Smith", time: "5 hrs ago", callType: .outgoing),
        Call(imageName: "person.crop.circle.badge.checkmark", userName: "Mike Ross", time: "1 day ago", callType: .missed),
        Call(imageName: "person.crop.circle.fill.badge.minus", userName: "Rachel Zane", time: "2 days ago", callType: .outgoing)
    ]
    @State var showMenu = false
    
    
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
                    
                    Text("Calls")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                       // showMenu = true
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
                
                // Call History List
                ScrollView {
                    ForEach(callHistory) { call in
                        CallHistoryCell(call: call)
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            
           // MoreOptionsView(showMenu: $showMenu)
        }
    }
}

struct CallHistoryCell: View {
    let call: CallHistoryScreen.Call
    
    var body: some View {
        HStack {
            // User Image
            Image(systemName: call.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .background(Circle().fill(Color.white.opacity(0.2)))
                .shadow(radius: 5)
                .padding(5)
            
            // User Name and Call Time
            VStack(alignment: .leading, spacing: 5) {
                Text(call.userName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(call.time)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Call Type Icon
            Image(systemName: call.callType.iconName)
                .font(.title2)
                .foregroundColor(call.callType.color)
                .padding(10)
                .background(Circle().fill(Color.white.opacity(0.2)))
                .shadow(radius: 5)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

struct CallHistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        CallHistoryScreen()
    }
}
