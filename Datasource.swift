//
//  Datasource.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class Datalink{
    static var shared: Datalink = Datalink()
    
    var firebaseLinked:Bool = false
}

class Datasource: ObservableObject{
    static var shared:Datasource = Datasource()
    
    
    var database: DatabaseConnection? {
        get{
            if Datalink.shared.firebaseLinked{
                return DatabaseConnection()
            }
            else{
                return nil
            }
        }
    }
    
    //var firebaseLinked:Bool = false
    
    @Published var activeGame: ListenerRegistration? = nil // remove listener when game ends
    @Published var isConnected: Bool = false
    
    @Published var gameStarted: Bool = false
    @Published var canMove: Bool = false
    @Published var madeMove: Bool = false
    @Published var player: Int = 1
    
    
    var username: String = "alex" //from storaged memory
    @Published var board: [String: [Int]] = [
        "colomn1": [0,0,0,0,0,0],
        "colomn2": [0,0,0,0,0,0],
        "colomn3": [0,0,0,0,0,0],
        "colomn4": [0,0,0,0,0,0],
        "colomn5": [0,0,0,0,0,0],
        "colomn6": [0,0,0,0,0,0],
        "colomn7": [0,0,0,0,0,0]]
    @Published var lastMove: [Any] = []
    
    @Published var backgrounds = ["colomn1": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn2": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn3": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn4": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn5": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn6": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn7": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no]]
    
    @Published var turn: Int = 1
    @Published var winner: String? = nil
    @Published var display: String = "Waiting for players"
    
    @Published var lobbies: [Lobby] = []
    @Published var lobby: Lobby? = nil
    @Published var foundLobbies:Bool = false

    private init(){}
    
}
