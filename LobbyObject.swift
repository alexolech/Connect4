//
//  LobbyObject.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-23.
//

import Foundation
import FirebaseFirestoreSwift

struct Lobby: Identifiable, Codable{
    
    //var id = UUID()
    @DocumentID var id: String?
    var name: String
    
    var isOpen: Bool = true
    
    var player1: String = ""
    var player2: String = ""
    
    var winner: String = ""
    
    var turn: Int = 1//SlotState
    var lastMove: [String] = ["colomn", "row"]
    //var lastMove: [Any] = []
    
    var board: [String: [Int]] = [ //SlotState
        "colomn1": [0,0,0,0,0,0,],
        "colomn2": [0,0,0,0,0,0,],
        "colomn3": [0,0,0,0,0,0,],
        "colomn4": [0,0,0,0,0,0,],
        "colomn5": [0,0,0,0,0,0,],
        "colomn6": [0,0,0,0,0,0,],
        "colomn7": [0,0,0,0,0,0,]
    ]
    
    //var lastMove: String
    
    var isFinished: Bool = false
    
    //score?
        
}
    

