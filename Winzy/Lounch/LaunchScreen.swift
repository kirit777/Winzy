import SwiftUI

struct LaunchScreen: View {
    @State private var dropW = false
    @State private var showLetters = false
    @State private var navigateToWalkthrough = false  // State to trigger navigation
    
    let letters = Array("inzy") // Letters that slide in
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackgroundView()
                FloatingShapes()
                
                VStack {
                    HStack(spacing: 5) {
                        Text("W")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.white)
                            .offset(y: dropW ? 0 : -300) // Drop from top
                            .animation(.interpolatingSpring(stiffness: 200, damping: 10).delay(0.1), value: dropW)
                        
                        HStack(spacing: 2) {
                            ForEach(letters.indices, id: \.self) { index in
                                Text(String(letters[index]))
                                    .font(.system(size: 80, weight: .bold))
                                    .foregroundColor(.white)
                                    .offset(x: showLetters ? 0 : 50) // Slide from right
                                    .opacity(showLetters ? 1 : 0) // Fade-in
                                    .animation(.easeOut(duration: 0.3).delay(0.4 + Double(index) * 0.2), value: showLetters)
                            }
                        }
                    }
                    .padding(.top, 100) // Add padding to simulate ground
                }
                .onAppear {
                    dropW = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showLetters = true
                    }
                    
                    // Navigate to AppWalkthroughScreen after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        navigateToWalkthrough = true
                    }
                }
                
                // Navigation Link to Walkthrough Screen
                if let isLoggedIn =  UserDefaultsManager.shared.get(forKey: UserDefaultsKeys.isLoggedIn.rawValue, as: String.self) {
                    if isLoggedIn == "1" {
                        NavigationLink("", destination: CustomeTabbarView(), isActive: $navigateToWalkthrough)
                            .hidden()
                    }else{
                        NavigationLink("", destination: AppWalkthroughScreen(), isActive: $navigateToWalkthrough)
                            .hidden()
                    }
                }else{
                    NavigationLink("", destination: AppWalkthroughScreen(), isActive: $navigateToWalkthrough)
                        .hidden()
                }
                
            }
        }
    }
}



struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
