//
//  AlertModel.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 05/06/2023.
//

import SwiftUI

enum AlertType {
    case win
    case lose
    case draw
    case quit
    
    var title: String {
        switch self {
        case .win:
            return "Win!"
        case .lose:
            return "Loss.."
        case .draw:
            return "Draw!"
        case .quit:
            return "You're alone."
        }
    }
    
    var message: String {
        switch self {
        case .win:
            return "Congratulations, you won!"
        case .lose:
            return "Better luck next time!"
        case .draw:
            return "Close one!"
        case .quit:
            return "Another player has already left the lobby."
        }
    }
}

struct AlertModel: Equatable {
    let id = UUID()
    let type: AlertType
    let shouldQuit = false
}
