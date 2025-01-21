//
//  StatusScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct StatusScreen: View {
    @State private var userStatus: String = "Feeling happy today!"
    @State private var statuses: [Status] = [
        Status(imageName: "person.crop.circle.fill", userName: "John Doe", timeAgo: "2 hrs ago"),
        Status(imageName: "person.crop.circle.fill.badge.plus", userName: "Jane Smith", timeAgo: "5 hrs ago"),
        Status(imageName: "person.crop.circle.badge.checkmark", userName: "Mike Ross", timeAgo: "1 day ago")
    ]
    @State var showMenu = false
    
    struct Status: Identifiable {
        let id = UUID()
        let imageName: String
        let userName: String
        let timeAgo: String
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
            
            FloatingShapes()

            
            VStack {
                // Navigation Bar
                HStack {
                    
                    Text("Status")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
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
                
                // Add Your Status Section
                VStack {
                    HStack {
                        Button(action: {
                            // Add image action
                        }) {
                            Image(systemName: "photo.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Circle().fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.green, Color.blue]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )))
                                .shadow(radius: 5)
                        }
                        
                        Text("Add your status")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.leading, 10)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                .padding(.top)
                
                // Status List Section
                ScrollView {
                    ForEach(statuses) { status in
                        StatusCell(status: status)
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            
           // MoreOptionsView(showMenu: $showMenu)
        }
    }
}

struct StatusCell: View {
    let status: StatusScreen.Status
    
    var body: some View {
        HStack {
            Image(systemName: status.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .background(Circle().fill(Color.white.opacity(0.2)))
                .shadow(radius: 5)
                .padding(5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(status.userName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(status.timeAgo)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

struct StatusScreen_Previews: PreviewProvider {
    static var previews: some View {
        StatusScreen()
    }
}
