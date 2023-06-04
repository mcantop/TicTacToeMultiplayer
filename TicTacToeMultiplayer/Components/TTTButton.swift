//
//  TTTButton.swift
//  TicTacToeMultiplayer
//
//  Created by Maciej on 04/06/2023.
//

import SwiftUI

enum TTTButtonType: String {
    case start
    case quit
    
    var text: String {
        return self.rawValue.capitalized
    }
}

struct TTTButton: View {
    // MARK: - Properties
    let type: TTTButtonType
    let action: () -> Void
    
    // MARK: - Init
    init(type: TTTButtonType, action: @escaping () -> Void) {
        self.type = type
        self.action = action
    }
    
    // MARK: - Computed Properties
    private var background: Color {
        switch type {
        case .start:
            return .green
        case .quit:
            return .red
        }
    }
    
    // MARK: - TTTButton View
    var body: some View {
        Button {
            action()
        } label: {
            Text(type.text)
                .font(.title3)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(background)
                .clipShape(Capsule())
                .padding(.horizontal, 64)
        }

    }
}

struct TTTButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TTTButton(type: .start) { }
            
            TTTButton(type: .quit) { }
        }
    }
}
