//
//  SearchScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct SearchScreen: View {
    @State private var searchQuery = ""
    @State private var selectedFilter: String = "Name"
    @State private var contacts = [
        Contact(name: "John Doe", status: "Hey, I’m available!", phoneNumber: "+123456789", image: "user1"),
        Contact(name: "Jane Smith", status: "Busy at work", phoneNumber: "+987654321", image: "user2"),
        Contact(name: "Emma White", status: "On a call", phoneNumber: "+112233445", image: "user3")
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Search Bar and Filters
                HStack {
                    TextField("Search", text: $searchQuery)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.leading, 10)
                        .shadow(radius: 5)
                    
                    Picker("Filter", selection: $selectedFilter) {
                        Text("Name").tag("Name")
                        Text("Phone").tag("Phone")
                        Text("Status").tag("Status")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(15)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .frame(width: 120)
                }
                .padding(.top, 50)
                .padding(.horizontal, 20)
                
                // Search Results List
                List {
                    ForEach(filteredContacts(), id: \.phoneNumber) { contact in
                        HStack {
                            Image(contact.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(contact.status)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // Online/Offline Indicator
                            Circle()
                                .fill(contact.status == "Hey, I’m available!" ? Color.green : Color.red)
                                .frame(width: 10, height: 10)
                        }
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal, 10)
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.top, 10)
                
                Spacer()
                
                // Add New Chat or Contact Floating Button
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            // Action for adding new chat or contact
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.blue))
                                .shadow(radius: 10)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .animation(.spring(), value: searchQuery)
    }
    
    // Filtered contacts based on search query and selected filter
    private func filteredContacts() -> [Contact] {
        return contacts.filter { contact in
            if selectedFilter == "Name" {
                return contact.name.lowercased().contains(searchQuery.lowercased())
            } else if selectedFilter == "Phone" {
                return contact.phoneNumber.contains(searchQuery)
            } else {
                return contact.status.lowercased().contains(searchQuery.lowercased())
            }
        }
    }
}

struct Contact {
    let name: String
    let status: String
    let phoneNumber: String
    let image: String
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
