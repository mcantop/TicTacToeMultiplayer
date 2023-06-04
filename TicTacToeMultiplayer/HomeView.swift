//
//  ContentView.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var presentingGameView = false
    
    var body: some View {
        VStack {
            // MARK: - Header
            VStack(spacing: 0) {
                Text("TicTacToe")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Multiplayer")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            // MARK: - Play Button
            Button {
                presentingGameView.toggle()
            } label: {
                Text("Play")
                    .font(.title3)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.tint)
                    .clipShape(Capsule())
                    .padding(64)
            }
            
            // MARK: - Footer
            Text("Powered by Firebase Firestore")
                .font(.footnote)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .fullScreenCover(isPresented: $presentingGameView) {
            GameView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
