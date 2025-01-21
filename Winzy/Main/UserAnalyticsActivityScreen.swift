//
//  UserAnalyticsActivityScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI
import Charts

struct UserAnalyticsActivityScreen: View {
    @State private var totalMessagesSent = 350
    @State private var totalCallsMade = 50
    @State private var totalMediaShared = 120
    @State private var frequentContactName = "John Doe"
    @State private var activeHours = [8, 4, 7, 10, 6, 2, 5]
    @State private var badges = ["Top Chat Master", "Media Maven", "Frequent Caller"]
    
    var body: some View {
        ZStack {
            // Background gradient
//            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
            
            GradientBackgroundView()
            
            FloatingShapes()

            
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Analytics & Activity")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                
                // Activity Stats Section
                VStack(alignment: .leading) {
                    // Total Messages Sent
                    AnalyticsCardView(title: "Total Messages Sent", count: totalMessagesSent)
                    
                    // Total Calls Made
                    AnalyticsCardView(title: "Total Calls Made", count: totalCallsMade)
                    
                    // Total Media Shared
                    AnalyticsCardView(title: "Total Media Shared", count: totalMediaShared)
                }
                .padding(.top, 20)
                
                // Chat Activity Graph
                VStack(alignment: .leading) {
                    Text("Chat Activity")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Chart {
                        ForEach(0..<activeHours.count, id: \.self) { index in
                            BarMark(x: .value("Day", index),
                                    y: .value("Active Hours", activeHours[index]))
                        }
                    }
                    .frame(height: 200)
                    .padding(.top, 10)
                }
                .padding(.top, 20)
                
                // Frequent Contact Section
                VStack(alignment: .leading) {
                    Text("Frequent Contact: \(frequentContactName)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        
                        Text(frequentContactName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)
                }
                .padding(.top, 20)
                
                // Badges Section
                VStack(alignment: .leading) {
                    Text("Badges & Achievements")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(badges, id: \.self) { badge in
                                BadgeView(badgeName: badge)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding()
            
            // Floating Action Button for Badges Section
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Add action to earn more badges
                    }) {
                        Image(systemName: "star.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct AnalyticsCardView: View {
    var title: String
    var count: Int
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Spacer()
                
                Text("\(count)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
            .padding()
            .background(Color.white.opacity(0.3))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
}

struct BadgeView: View {
    var badgeName: String
    
    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .font(.title)
                .foregroundColor(.yellow)
                .padding()
                .background(Color.white.opacity(0.3))
                .clipShape(Circle())
                .shadow(radius: 10)
            
            Text(badgeName)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top, 5)
        }
    }
}

struct UserAnalyticsActivityScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserAnalyticsActivityScreen()
    }
}
