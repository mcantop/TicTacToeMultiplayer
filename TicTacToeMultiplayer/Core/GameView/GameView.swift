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
    @State private var presentingAlert = false
    
    var body: some View {
        VStack {
            GameHeaderView()
            
            GameGridView()
                .disabled(viewModel.checkGameBoardStatus())
                .animation(.spring(), value: viewModel.checkGameBoardStatus())
            
            TTTButton(type: .quit) {
                viewModel.quitGame()
                dismiss()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            viewModel.getTheGame()
        }
        .onChange(of: viewModel.alert) { alert in
            print("[DEBUG] Chaged alert \(alert)")
            presentingAlert = false
            presentingAlert = alert != nil
        }
        .onChange(of: viewModel.game) { game in
            if game == nil {
                viewModel.alert = AlertModel(type: .quit)
            }
        }
        .alert(
            viewModel.alert?.type.title ?? "",
            isPresented: $presentingAlert
        ) {
            Button("Quit", role: .destructive) {
                viewModel.quitGame()
                dismiss()
            }
            
            Button("Rematch", role: .cancel) {
                viewModel.resetGame()
            }
        } message: {
            Text(viewModel.alert?.type.message ?? "")
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
    @EnvironmentObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            if viewModel.game?.playerTwoId != "" {
                Text("Game has started!")
                    .font(.footnote)
                    .foregroundColor(.green)
                    .frame(maxHeight: .infinity, alignment: .top)
            } else {
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
                        
                        Image(systemName: viewModel.game?.moves[index]?.indicator ?? "")
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
