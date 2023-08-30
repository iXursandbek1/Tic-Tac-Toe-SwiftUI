//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by Xursandbek Qambaraliyev on 29/08/23.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
 
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "" )
                        }
                        .onTapGesture {
                            
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisable)
            .padding()
            
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.massage,
                      dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame() }))
            })
        }
    }
}

enum Player {
    case human, computer
}

struct Move {
    var player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}


