import SwiftUI
import LocalAuthentication

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showAuthError = false
    @Published var authErrorMessage = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access TVMaze"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                Task { @MainActor in
                    if success {
                        self.isAuthenticated = true
                        self.hasCompletedOnboarding = true
                    } else {
                        self.authErrorMessage = error?.localizedDescription ?? "Authentication failed"
                        self.showAuthError = true
                    }
                }
            }
        } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Please enter your device passcode"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                Task { @MainActor in
                    if success {
                        self.isAuthenticated = true
                        self.hasCompletedOnboarding = true
                    } else {
                        self.authErrorMessage = error?.localizedDescription ?? "Authentication failed"
                        self.showAuthError = true
                    }
                }
            }
        } else {
            authErrorMessage = "No authentication method available"
            showAuthError = true
        }
    }
}
