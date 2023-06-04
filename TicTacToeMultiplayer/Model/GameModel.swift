//
//  GameModel.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import Foundation

struct Game: Codable, Equatable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let playerOneId: String
    var playerTwoId: String
    let winnerId: String
    let rematchPlayerId: [String]
    var blockMoveForPlayerId: String
    
    var moves: [Move?]
}
