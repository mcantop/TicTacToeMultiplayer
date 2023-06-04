//
//  GameViewModel.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import SwiftUI
import Combine


final class GameViewModel: ObservableObject {
    @AppStorage("user") private var userData: Data?
    
    @Published var game: Game?
    
    @Published var currentUser: User?
    
    let columns: [GridItem] = [.init(), .init(), .init()]
    
    private let winPatterns: Set<Set<Int>> = [
        [0, 1, 2], [3, 4, 5],
        [6, 7, 8], [0, 3, 6],
        [1, 4, 7], [2, 5, 8],
        [0, 4, 8], [2, 4, 6],
    ]
    
    private var playedMoves: [Move] {
        return game?.moves.compactMap { $0 } ?? []
    }
    
    private var didDraw: Bool {
        return playedMoves.count == 9
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        getLocalUser()
        
        if currentUser == nil {
            createLocalUser()
        }
        
        
    }
}

// MARK: - Public API
extension GameViewModel {
    func getTheGame() {
        guard let userId = currentUser?.id else {
            print("[DEBUG] Current user id not found")
            return
        }
        
        GameService.shared.startGame(userId: userId)
        GameService.shared.$game
            .assign(to:\.game, on: self)
            .store(in: &cancellables)
    }
    
    func processPlayerMove(gridIndex: Int) {
        guard game != nil else {
            print("[DEBUG] Game in GameViewModel is nil")
            return
        }
        /// If grid is not already marked, continue move, otherwise return
        guard !isGridMarked(index: gridIndex) else { return }
        game?.moves[gridIndex] = Move(isPlayerOne: true, boardIndex: gridIndex)

        /// Block the move
        game?.blockMoveForPlayerId = "playerTwo"

        /// Check for win
        if didWin(playerOne: true) {
            print("[DEBUG] Win")
            return
        }

        if didDraw {
            print("[DEBUG] Draw")
            return
        }
    }
    
    func quitGame() {
        GameService.shared.quitGame()
    }
}

// MARK: - Private API
private extension GameViewModel {
    func isGridMarked(index: Int) -> Bool {
        guard let moves = game?.moves else { return false }
        return moves.contains { $0?.boardIndex == index }
    }
    
    func didWin(playerOne: Bool) -> Bool {
        /// Filter moves for a player
        let playerMoves = playedMoves.filter { $0.isPlayerOne == playerOne }
        /// Get a set of player moves as an index
        let playerPositons = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositons) {
            return true
        }
        
        return false
    }
    
    func createLocalUser() {
        currentUser = User()
        guard let encodedUserData = try? JSONEncoder().encode(currentUser) else { return }
        userData = encodedUserData
        print("[DEBUG] Created and saved a new user..")
    }
    
    func getLocalUser() {
        guard let userData else { return }
        guard let decodedUser = try? JSONDecoder().decode(User.self, from: userData) else { return }
        currentUser = decodedUser
        print("[DEBUG] Decoded a local user..")
    }
}
