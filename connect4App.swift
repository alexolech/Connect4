//
//  connect4App.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-18.
//

import SwiftUI

@main
struct connect4App: App {
    
    var gameLogic:GameLogic = GameLogic()
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            LocalGameView().environmentObject(gameLogic)
        }
    }
}
