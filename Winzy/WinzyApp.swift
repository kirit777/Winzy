//
//  WinzyApp.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import UserNotifications
import FirebaseMessaging


@main
struct WinzyApp: App {
    // Configure the AppDelegate to handle push notifications and Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
            //AppWalkthroughScreen()
            //CustomeTabbarView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
        // Initialize Firebase
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
           var urlSchemes = urlTypes.first?["CFBundleURLSchemes"] as? [String] {
            // Add your URL scheme programmatically
            urlSchemes.append("com.kirit.Winzy")
            urlSchemes.append("kirit.Winzy")
            urlSchemes.append("app-1-830750242654-ios-b19b085debcc5dea0301cf")
        }
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Register device token with Firebase Cloud Messaging (FCM)
        
        
        
        
        Messaging.messaging().apnsToken = deviceToken
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle silent notification
        if let message = userInfo["message"] as? String {
            print("Silent notification received with message: \(message)")
            // Perform any necessary background tasks here
            
            // You can post the notification to update the UI
            NotificationCenter.default.post(name: Notification.Name("SilentNotificationReceived"), object: message)
        }
        
        // Ensure to call the completion handler
        completionHandler(.newData)
    }
}
