//
//  GameView.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import SwiftUI

struct GameView: View {
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack { 
            GameHeaderView()
            
            GameGridView()
            
            TTTButton(type: .quit) {
                dismiss()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameViewModel())
    }
}

// MARK: - Private Views

// MARK: GameHeaderView
struct GameHeaderView: View {
    var body: some View {
        VStack {
            Text("Waiting for a player to join...")
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxHeight: .infinity, alignment: .top)
            
            ProgressView()
                .scaleEffect(1.75)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

// MARK: GameGridView
struct GameGridView: View {
    @EnvironmentObject var viewModel: GameViewModel

    var body: some View {
        LazyVGrid(columns: viewModel.columns) {
            ForEach(0..<9) { index in
                Button {
                    viewModel.processPlayerMove(gridIndex: index)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.tint)
                        
                        Image(systemName: viewModel.game.moves[index]?.indicator ?? "")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .padding(24)
                    }
                }
            }
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
    }
}
