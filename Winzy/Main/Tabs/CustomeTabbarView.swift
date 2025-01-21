//
//  CustomeTabbarView.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 30/12/24.
//

import SwiftUI

struct CustomeTabbarView: View {
    var body: some View {
        TabView {
                UserListScreen()
                .tabItem {
                    Image(systemName: "message.fill")
                }

            StatusScreen()
                .tabItem {
                    Image(systemName: "circle.grid.2x2.fill")
                    Text("Search")
                }

            CallHistoryScreen()
                .tabItem {
                    Image(systemName: "phone.fill")
                    Text("Profile")
                }
        }
        .accentColor(.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}




#Preview {
    CustomeTabbarView()
}
