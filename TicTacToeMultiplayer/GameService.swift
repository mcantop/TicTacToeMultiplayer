//
//  FirebaseService.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import Combine
import Firebase
import FirebaseFirestoreSwift

final class GameService: ObservableObject {
    @Published var game: Game?

    static let shared = GameService()
    private let firebaseReference = Firestore.firestore().collection("game")
}

// MARK: - Public API
extension GameService {
    func startGame(userId: String) {
        /// Check if there is a game to join, if no - create one
        /// If so, we will join and start listening for in-game changes
        firebaseReference
            .whereField("playerTwoId", isEqualTo: "")
            .whereField("playerOneId", isNotEqualTo: userId)
            .getDocuments { snapshot, error in
                if error != nil {
                    print("[DEBUG] Error while starting a game: it probably does not exist. Creating a new game.")
                    /// Create new game
                    self.createGameObject(userId: userId)
                    return
                }
                
                if let document = snapshot?.documents.first {
                    do {
                        let decodedGame = try document.data(as: Game.self)
                        self.game = decodedGame
                        self.game?.playerTwoId = userId
                        self.game?.blockMoveForPlayerId = userId
                        self.updateGameOnline(game: self.game)
                        self.listenForGameChanges()
                    } catch {
                        print("[DEBUG] Error while decoding game object: \(error.localizedDescription)")
                    }
                } else {
                    self.createGameObject(userId: userId)
                }
            }
    }
    
    func createGameObject(userId: String) {
        print("[DEBUG] Creating game object for userId: \(userId)")
        
        game = Game(
            id: UUID().uuidString,
            playerOneId: userId,
            playerTwoId: "",
            winnerId: "",
            rematchPlayerId: [],
            blockMoveForPlayerId: userId,
            moves: Array(repeating: nil, count: 9)
        )
        
        updateGameOnline(game: game)
        listenForGameChanges()
    }
    
    func updateGameOnline(game: Game?) {
        do {
            guard let game else { fatalError("[DEBUG] Game object shouldn't be nil!!!") }
            try firebaseReference.document(game.id).setData(from: game)
        } catch {
            print("[DEBUG] Error while creating online game: \(error.localizedDescription)")
        }
    }
    
    func listenForGameChanges() {
        guard let gameId = game?.id else { fatalError("[DEBUG] Game object shouldn't be nil!!!") }
        firebaseReference.document(gameId).addSnapshotListener { snapshot, error in
            if let error {
                print("[DEBUG] Error while listening for game changes: \(error.localizedDescription)")
                return
            }
            
            if let snapshot {
                self.game = try? snapshot.data(as: Game.self)
//                do {
//                    self.game = try snapshot.data(as: Game.self)
//                    print("[DEBUG] Listening for snapshot change")
//                } catch {
//                    self.game = nil
//                    print("[DEBUG] Error while decoding game changes snapshot: \(error.localizedDescription)")
//                }
            }
        }
    }
    
    func quitGame() {
        guard game != nil else {
            print("[DEBUG] No game object found. It either does not exist or has been already deleted before")
            return
        }
        
        if let gameId = game?.id {
            firebaseReference.document(gameId).delete()
//            game = nil
            print("[DEBUG] Deleting game from Firebase")
        }
    }
}
