//
//  GameView.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import SwiftUI

struct GameView: View {
    @Environment (\.dismiss) var dismiss
    
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
    private let columns: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<9) { index in
                Button {
                    print("[DEBUG] Tapped on index \(index)")
                } label: {
                    ZStack {
                        Circle()
                            .fill(.tint)
                        
                        Image(systemName: "apple.logo")
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
