//
//  Move.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import Foundation

struct Move: Codable {
    let isPlayerOne: Bool
    let boardIndex: Int
    
    var indicator: String {
        return isPlayerOne ? "xmark" : "circle"
    }
}
