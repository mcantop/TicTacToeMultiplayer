//
//  GameModel.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import Foundation

struct Game: Codable {
    let id: String
    let playerOneId: String
    let playerTwoId: String
    let winnerId: String
    let rematchPlayerId: [String]
    var blockMoveForPlayerId: String
    
    var moves: [Move?]
}
