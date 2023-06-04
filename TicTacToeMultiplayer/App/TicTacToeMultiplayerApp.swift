//
//  TicTacToeMultiplayerApp.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import SwiftUI
import Firebase

@main
struct TicTacToeMultiplayerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase == .inactive {
                        GameService.shared.quitGame()
                    }
                    
                    if newScenePhase == .background {
                        GameService.shared.quitGame()
                    }
                }
        }
    }
}
