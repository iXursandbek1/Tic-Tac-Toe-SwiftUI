//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Xursandbek Qambaraliyev on 30/08/23.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisable = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        
        if isSquareOccupied(in: moves, forIndrx: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        //check for win condition or drow
        if checkWinConditon(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisable = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let compiuterPosition = determineComputerMovePosition(in: moves)
            moves[compiuterPosition] = Move(player: .computer, boardIndex: compiuterPosition)
            isGameboardDisable = false
            
            if checkWinConditon(for: .computer, in: moves) {
                alertItem = AlertContext.compiuterWin
                return
            }
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndrx index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(computerPositions)
            
            if winPosition.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndrx: winPosition.first!)
                if isAvaiable { return winPosition.first! }
            }
        }
        // If AI can't win then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPosition = pattern.subtracting(humanPositions)
            
            if winPosition.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndrx: winPosition.first!)
                if isAvaiable { return winPosition.first! }
            }
        }
        
        // If AI can't block, then take a middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndrx: centerSquare) {
            return centerSquare
        }
        
        // If AI can't take middle square , then take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndrx: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinConditon (for player: Player, in moves: [Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        return false
    }
    
    func checkForDraw(in movies: [Move?]) -> Bool {
        return movies.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
