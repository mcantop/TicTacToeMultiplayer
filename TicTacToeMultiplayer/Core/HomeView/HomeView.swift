//
//  ContentView.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            HomeHeader()
            
            TTTButton(type: .start) {
                viewModel.presentingGameView = true
            }
            
            HomeFooter()
        }
        .fullScreenCover(isPresented: $viewModel.presentingGameView) {
            GameView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: - Private Views

// MARK: HomeHeader
private struct HomeHeader: View {
    var body: some View {
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
    }
}

// MARK: HomeFooter
private struct HomeFooter: View {
    var body: some View {
        Text("Powered by Firebase Firestore")
            .font(.footnote)
            .fontWeight(.light)
            .foregroundColor(.secondary)
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
}
