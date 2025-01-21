# Winzy



# Winzy - Chat App

[Winzy GitHub Repository](https://github.com/kirit777/Winzy)

Winzy is a real-time chat application built using **SwiftUI** and **Firebase**. The app offers a clean and modern user interface for seamless communication between users. The app features text-based chat, real-time updates, and Firebase as the backend service for managing users, messages, and authentication.

## Features

- **Real-time Messaging**: Send and receive messages instantly.
- **User Authentication**: Firebase Authentication to log in and sign up users.
- **Unique UI Design**: A custom, user-friendly, and sleek UI design built with SwiftUI.
- **Cloud Firestore Integration**: Firebase Firestore database to store user and message data.
- **Push Notifications**: Get notified when you receive a new message (Future feature).

## Technologies Used

- **SwiftUI**: For building the user interface.
- **Firebase**: For real-time database, user authentication, and storing messages.
- **Firebase Authentication**: To authenticate users with email/password.
- **Firebase Firestore**: To store and retrieve messages and user data.

## Screenshots

### Main Chat Screen
![Main Screen](path-to-your-screenshot.jpg)

### User Authentication
![Auth Screen](path-to-your-screenshot.jpg)

### Message Sending
![Message Screen](path-to-your-screenshot.jpg)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/kirit777/Winzy.git
   ```

2. Open the project in **Xcode**.

3. Install dependencies (if using **CocoaPods**):
   ```bash
   pod install
   ```

4. Open the `.xcworkspace` file in Xcode.

5. Set up Firebase:
   - Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   - Add your iOS app to the Firebase project.
   - Download the `GoogleService-Info.plist` file and add it to the Xcode project.
   - Enable Firebase Authentication and Firestore.

6. Run the project on your simulator or device.

## Firebase Setup

To set up Firebase for the project, follow the instructions below:

1. Go to the [Firebase Console](https://console.firebase.google.com/), create a project, and add an iOS app.
2. Download the **GoogleService-Info.plist** file and add it to your project.
3. In your Firebase project settings, enable **Firebase Authentication** (email/password) and **Cloud Firestore**.
4. Follow the [Firebase iOS setup guide](https://firebase.google.com/docs/ios/setup) to complete the configuration.

## UI Design Details

- **Chat UI**: The app features a conversational layout with user profile images, message bubbles, and timestamps.
- **Authentication UI**: A simple login and sign-up interface where users can log in using email and password.

## Future Enhancements

- Push notifications for new messages.
- Add more chat features like images, stickers, and voice messages.
- Group chat functionality.
- Profile customization options.

## Contributing

If you want to contribute to this project, feel free to fork the repository and make pull requests. Any contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
