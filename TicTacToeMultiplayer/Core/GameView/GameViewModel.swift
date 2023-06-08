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
    @Published var game: Game? {
        didSet {
                checkIsGameOver()
        }
    }
    @Published var currentUser: User?
    @Published var alert: AlertModel?
    
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
    
     var didWin: Bool {
        /// Filter moves for a player
        let playerMoves = playedMoves.filter { $0.isPlayerOne == isPlayerOne }
        /// Get a set of player moves as an index
        let playerPositons = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositons) {
            return true
        }
        
        return false
    }
    
     var didDraw: Bool {
        return playedMoves.count == 9
    }
    
    private var isPlayerOne: Bool {
        guard let game else { return false }
        return game.playerOneId == currentUser?.id
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
        guard game != nil, let currentUser else {
            print("[DEBUG] Game or currentUser is nil")
            return
        }
        /// If grid is not already marked, continue move, otherwise return
        guard !isGridMarked(index: gridIndex) else { return }
        game?.moves[gridIndex] = Move(isPlayerOne: isPlayerOne, boardIndex: gridIndex)
        
        /// Block the move
        game?.blockMoveForPlayerId = currentUser.id
        
        GameService.shared.updateGameOnline(game: game)
        
        if didWin {
            game?.winnerId = currentUser.id
            GameService.shared.updateGameOnline(game: game)
            return
        }
        
        if didDraw {
            game?.winnerId = "0"
            GameService.shared.updateGameOnline(game: game)
            return
        }
    }
    
    func checkGameBoardStatus() -> Bool {
        guard let game else { return false }
        return game.blockMoveForPlayerId == currentUser?.id
    }
    
    func checkIsGameOver() {
        alert = nil
        
        guard let game else { return }
                
        if game.winnerId == "0" {
            alert = AlertModel(type: .draw)
        } else if game.winnerId != "" {
            if game.winnerId == currentUser?.id {
                alert = AlertModel(type: .win)
            } else {
                alert = AlertModel(type: .lose)
            }
        }
        
        if game == nil {
            print("[DEBUG] GAME NIL")
        }
    }
    
    func quitGame() {
        GameService.shared.quitGame()
    }
    
    func resetGame() {
        guard game != nil else {
            alert = AlertModel(type: .quit)
            return
        }
                
        if game?.rematchPlayerId.count == 1 {
            game?.moves = Array(repeating: nil, count: 9)
            game?.winnerId = ""
            game?.blockMoveForPlayerId = game?.playerTwoId ?? ""
        } else if game?.rematchPlayerId.count == 2 {
            game?.rematchPlayerId = []
        }
        
        game?.rematchPlayerId.append(currentUser?.id ?? "")
                
        GameService.shared.updateGameOnline(game: game)
    }

}

// MARK: - Private API
private extension GameViewModel {
    func isGridMarked(index: Int) -> Bool {
        guard let moves = game?.moves else { return false }
        return moves.contains { $0?.boardIndex == index }
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
