//
//  GameViewModel.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var game = Game(
        id: UUID().uuidString,
        playerOneId: "playerOne",
        playerTwoId: "playerTwo",
        winnerId: "",
        rematchPlayerId: [],
        blockMoveForPlayerId: "playerTwo",
        moves: Array(repeating: nil, count: 9)
    )
    
    let columns: [GridItem] = [.init(), .init(), .init()]
}

// MARK: - Public API
extension GameViewModel {
    func processPlayerMove(gridIndex: Int) {
        /// If grid is not already marked, continue move, otherwise return
        guard !isGridMarked(moves: game.moves, index: gridIndex) else { return }
        game.moves[gridIndex] = Move(isPlayerOne: true, boardIndex: gridIndex)

        /// Block the move
        
        /// Check for win
        
        /// Check for draw
    }
}

// MARK: - Private API
private extension GameViewModel {
    func isGridMarked(moves: [Move?], index: Int) -> Bool {
        return moves.contains { $0?.boardIndex == index }
    }
}
