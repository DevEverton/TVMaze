import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image("tvmaze-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .padding()
            
            VStack(spacing: 20) {
                Text("Welcome to TVMaze")
                    .font(.title)
                    .bold()
                
                Text("Discover and track your favorite TV shows, get episode details, and never miss a show again!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.authenticateUser()
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .alert("Authentication Error", isPresented: $viewModel.showAuthError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.authErrorMessage)
        }
    }
}
