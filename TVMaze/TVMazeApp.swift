//
//  TVMazeApp.swift
//  TVMaze
//
//  Created by Everton Carneiro on 23/04/25.
//

import SwiftUI

@main
struct TVMazeApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            ShowsListView()
                .fullScreenCover(isPresented: .constant(!hasCompletedOnboarding)) {
                    OnboardingView()
                }
        }
    }
}
