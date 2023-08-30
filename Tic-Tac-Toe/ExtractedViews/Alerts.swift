//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Xursandbek Qambaraliyev on 29/08/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var massage: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin     = AlertItem(title: Text("You Win"),
                                        massage: Text("You are so smart to beat AI."),
                                        buttonTitle: Text("Yeah 👏 👍"))
    
    static let compiuterWin = AlertItem(title: Text("You Lost"),
                                        massage: Text("You programmed super AI."),
                                        buttonTitle: Text("Remach"))
    
    static let draw         = AlertItem(title: Text("Draw"),
                                        massage: Text("What a battle of wits we have here .... "),
                                        buttonTitle: Text("Rry again."))
}
