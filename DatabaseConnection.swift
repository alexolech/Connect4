//
//  DatabaseConnection.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-23.
//

import Foundation

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift



class DatabaseConnection: ObservableObject{
    
    
    let db = Firestore.firestore()
    @Published var gameData = Datasource.shared
    
    
    
    var openLobbies: [Lobby] = []
    
    func gameOver(game: Lobby){
        let lobby = db.collection("lobbies").document(game.id!)
        
        print("winner found")
        lobby.updateData(["winner" : UserDefaults.standard.string(forKey: "username")!])
        lobby.updateData(["isFinished": true])
    }
    
    func makeMove(game: Lobby){
        let lobby = db.collection("lobbies").document(game.id!)
        print(self.gameData.board)
        
        
        if self.gameData.player == 2{
            print("player 2 went now its player 1s turn")
            
            lobby.updateData(["turn": 1])

        }
        else if self.gameData.player == 1{
            print("player 1 went now its player 2s turn")
            //lobby.setData(["board": self.gameData.board])
            lobby.updateData(["turn": 2])
        }
        
        lobby.updateData(["lastMove": self.gameData.lastMove])
        lobby.updateData(["board": self.gameData.board])
        
    }
    
    func add10Lobies(){
        let lobbies = db.collection("lobbies")
        do{
            for num in (1...3){
                let newLobby = Lobby(name: "lobby-\(num)")
                let newdDoc = try lobbies.addDocument(from: newLobby)
                print(newdDoc)
//                lobbies.addDocument(data: [
//                    "isOpen": true,
//                    "isFinished": false,
//                    "player1": "",
//                    "player2": "",
//                    "turn": 1,
//                    "board": ["colomn1": [0,0,0,0,0,0,],
//                              "colomn2": [0,0,0,0,0,0,],
//                              "colomn3": [0,0,0,0,0,0,],
//                              "colomn4": [0,0,0,0,0,0,],
//                              "colomn5": [0,0,0,0,0,0,],
//                              "colomn6": [0,0,0,0,0,0,],
//                              "colomn7": [0,0,0,0,0,0,]
//                             ]
//                ]).
            }
            
        }
        catch{
            print("error")
        }
        
    }
    
    
    func gameSession(game: Lobby){
        
        let lobby = db.collection("lobbies").document(game.id!)
        
        Datasource.shared.activeGame = lobby.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            //print("Current data: \(data)")
            print("\(UserDefaults.standard.string(forKey: "username")!) is player\(self.gameData.player)")
            
            //two player in lobby
            if data["isOpen"] as! Bool == false{
                
                self.gameData.gameStarted = true
            }
            
            
            
            //update game state as long as game isnt won
            if data["isFinished"] as! Bool{
                //if opponent wins, read database one more time
                
                //game over
                //reset lobby
                //disconnect players
                self.gameData.winner = (data["winner"] as! String)
                self.gameData.display = "\(String(describing: self.gameData.winner)) wins!"
                //InGameView(lobbyName: game).refresh()
                self.gameData.activeGame!.remove()
                
            }
            else{
                
                self.gameData.board = data["board"] as! [String: [Int]]
                print(self.gameData.board)
                self.gameData.turn = data["turn"] as! Int
                self.gameData.lastMove = data["lastMove"] as! [Any]
                
                print(self.gameData.turn)
                print(self.gameData.player)
                print(self.gameData.lastMove)
                
                print("Database")
                self.gameData.display = "\(data["player\(data["turn"] as! Int)"] as! String)'s turn"
                print(self.gameData.display)
                if self.gameData.player == self.gameData.turn{//} && !self.gameData.madeMove{
                    self.gameData.canMove = true
                    //self.gameData.display = "\(data["player\(data["turn"] as! Int)"] as! String)"
                    //self.gameData.display = "Your turn"
                    print("is my turn")
                }
                else{
                    print("is oppenent turn")
                    //self.gameData.display = "Opponent's turn"
                }
                
                //InGameView(lobbyName: game).refresh()
                
                //user made move (turn changed after UI input)
//                if self.gameData.madeMove{
//                    //update database
//                    print("user made move")
//                    self.gameData.canMove = false
//
//                    if self.gameData.player == 2{
//                        print("player 2 went now its player 1s turn")
//                        lobby.updateData(["board": self.gameData.board])
//                        lobby.updateData(["turn": 1])
//
//                    }
//                    else if self.gameData.player == 1{
//                        print("player 1 went now its player 2s turn")
//                        lobby.updateData(["board": self.gameData.board])
//                        lobby.updateData(["turn": 2])
//                    }
//                    //self.gameData.madeMove = false
//
//                }
                
                //opponent move made
//                if self.gameData.board != data["board"] as! [String: [Int]] && self.gameData.madeMove{
//                    print("opponent made move and now its my turn")
//                    self.gameData.board = data["board"] as! [String: [Int]]
//                    self.gameData.turn = data["turn"] as! Int
//                    self.gameData.madeMove = false
//                    //self.gameData.lastMove = data["lastMove"] as! String
//
//                }
                
                
            }
        }
        
    }
    
    func sendLobbies() -> [Lobby]{
        return self.openLobbies
    }
    
    func getOpenLobbies(){
    //async
    //-> [Lobby]{
        
        let lobbies = db.collection("lobbies")
        //var openLobbies: [Lobby] = []
        
        print("looking for lobbies")
        
        Datasource.shared.lobbies = [] //reset list
        //async
        
        
        
        
                lobbies.whereField("isOpen", isEqualTo: true).getDocuments(){ query, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                }
                    else {
                        for document in query!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let ref = document.data()
                            let id = document.documentID
                            let lobby = Lobby(
                                id: id,
                                name: ref["name"] as! String,
                                isOpen: ref["isOpen"] as! Bool,
                                player1: ref["player1"] as! String,
                                player2: ref["player2"] as! String,
                                turn: ref["turn"] as! Int,
                                board: ref["board"] as! [String : [Int]],
                                isFinished: ref["isFinished"] as! Bool
                            )
                            //print(lobby.isOpen)
                            Datasource.shared.lobbies.append(lobby)

                            self.openLobbies.append(lobby)
                        }
                        Datasource.shared.foundLobbies = true
                        print(self.openLobbies)
                        //self.gameData.lobbies = self.openLobbies
                        //return openLobbies
                    }
                }
            

        
        
//            .getDocuments { query, error in
//                if let error = error {
//                    print("Error getting documents: \(error)")
//                }
//                else {
//                    for document in query!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                        let ref = document.data()
//                        let name = document.documentID
//                        let lobby = Lobby(
//                            name: name,
//                            isOpen: ref["isOpen"] as! Bool,
//                            player1: ref["player1"] as! String,
//                            player2: ref["player2"] as! String,
//                            turn: ref["turn"] as! Int,
//                            //board: ref["board"] as! [String : [Int]],
//                            isFinished: ref["isFinished"] as! Bool
//                        )
//                        print(lobby.isOpen)
//                        openLobbies.append(lobby)
//                    }
//                }
        
    }
    
    func joinLobby(game: Lobby) async -> Bool{
        let lobby = db.collection("lobbies").document(game.id!)
        //self.gameData.isConnected = false
        var isConnected = false
        

        
        

            //if lobby.value(forKey: "isOpen") as! Int == 1{
                //let player1 = lobby.value(forKey: "player1") as! String
                //let player2 = lobby.value(forKey: "player2") as! String
                
                let listener = lobby.addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    
                    print("Current data: \(data)")
                    
                    guard data["isOpen"] as! Bool else{
                        return
                    }
                    
                    //empty lobby
                    if data["player1"] as! String == "" && data["player2"] as! String == "" && !isConnected{
                        //connecting
                        print("empty lobby")
                        guard data["player1"] as! String == ""
                        else{
                            //player1 got filled
                            print("player1 filled")
                            guard data["player2"] as! String == ""
                            else{
                                //player2 got filled
                                print("player2 filled")
                                return
                            }
                            //make user player 2
                            self.gameData.player = 2
                            lobby.updateData(["player2": UserDefaults.standard.string(forKey: "username")!])
                            isConnected = true
                            //self.gameSession(game: game)
                            self.gameData.board = data["board"] as! [String: [Int]]
                            print("user is player 2")
                            return
                        }
                        //make user player 1
                        self.gameData.player = 1
                        lobby.updateData(["player1": UserDefaults.standard.string(forKey: "username")!])
                        print("user is player 1")
                        isConnected = true
                        //self.gameSession(game: game)
                        self.gameData.board = data["board"] as! [String: [Int]]
                    }
                    
                    //player 1 taken
                    if data["player1"] as! String != "" && data["player2"] as! String == "" && !isConnected{
                        //connecting
                        
                        guard data["player2"] as! String == ""
                        else{
                            //player2 got filled
                            return
                        }
                        //make user player 2
                        self.gameData.player = 2
                        lobby.updateData(["player2": UserDefaults.standard.string(forKey: "username")!])
                        isConnected = true
                        //self.gameSession(game: game)
                        self.gameData.board = data["board"] as! [String: [Int]]
                    }
                    
                    //player 2 taken
                    if data["player1"] as! String == "" && data["player2"] as! String != "" && !isConnected{
                        //connecting
                        
                        guard data["player1"] as! String == ""
                        else{
                            //player1 got filled
                            return
                        }
                        //make user player 1
                        self.gameData.player = 1
                        lobby.updateData(["player1": UserDefaults.standard.string(forKey: "username")!])
                        isConnected = true
                        
                        self.gameData.board = data["board"] as! [String: [Int]]
                    }
                    
                    //both spots filled
                    if data["player1"] as! String != "" && data["player2"] as! String != ""{
                        
                        lobby.updateData(["isOpen": false])
                        
                        
                        
                        //remove lobby from openLobbies list
                        //self.gameData.lobbies =
                    }
                    return
                }
                //listener.remove()
                
            //}
        
        
        //print(lobby.value(forKey: "isOpen"))

        
        
        do{
            try await Task.sleep(nanoseconds: 1000000000)
//            if isConnected{
//
//            }
//            else{
//                //replace defaul
//            }

            listener.remove()
            
            return isConnected
        }
        
        catch{
            print("error")
            listener.remove()
            return isConnected
        }
        
    }
}
