//
//  InGameView.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-24.
//

import SwiftUI

extension Int{
    func toColor() -> Color{
        switch self{
        case 1:
            return Color.red
        case 2:
            return Color.yellow
        default:
            return Color.blue
        }
    }
}

struct InGameView: View {
    var lobbyName: Lobby
    
    @EnvironmentObject var gameLogic:GameLogic
    @State private var display: String = "Waiting for Players"
    @State private var turn: Int = 1
    @State var board: [String: [Int]] = [
        "colomn1": [0,0,0,0,0,0],
        "colomn2": [0,0,0,0,0,0],
        "colomn3": [0,0,0,0,0,0],
        "colomn4": [0,0,0,0,0,0],
        "colomn5": [0,0,0,0,0,0],
        "colomn6": [0,0,0,0,0,0],
        "colomn7": [0,0,0,0,0,0]]
    
    @State private var across: Bool = false
    @State private var pieceFalling = false
    
    @State var connected = false
    @State var checked = false
    
    var body: some View {
        
        VStack{
            
            if self.connected{
                //game in here
                
                VStack{
                    Text("Connect 4 to win").font(.title).padding(20)
                    Text(display).font(.title2).foregroundColor(turn.toColor())
                    VStack{
                        HStack{
                            ForEach(1..<8) { row in
                                VStack{
                                    //self.currentRow = []
                                    ForEach(0..<6) { line in
                                        
                                        Button(action: {
                                            if gameLogic.gameData.gameStarted{
                                                if gameLogic.gameData.winner == nil{
                                                    if gameLogic.gameData.player == gameLogic.gameData.turn{
                                                        //if gameLogic.gameData.canMove{ //&&!gameLogic.gameData.madeMove{
                                                        if (!pieceFalling){
                                                            gameLogic.gameData.lobby = lobbyName
                                                            gameLogic.playTurn(row: "colomn\(row)")
                                                            
                                                        }
                                                    }
                                                    else{
                                                        print("not your turn")
                                                    }
                                                }
                                                else{
                                                    print("there is a winner")
                                                    print(self.gameLogic.gameData.winner as Any)
                                                }
                                            }
                                            else{
                                                print("game hasn't started yet (waiting for oppenent)")
                                            }
                                            
                                            
                                        })
                                        {
                                            //slot =
                                            Text("O").foregroundColor(board["colomn\(row)"]?[line].toColor())
                                            .font(.title).bold().frame(maxWidth: UIScreen.main.bounds.width/8.75, maxHeight: UIScreen.main.bounds.width/8.75 ).background(gameLogic.backgrounds["colomn\(row)"]?[line].toColor())}
                                        //currentRow.append(slot)
                                    }
                                }
                                //self.matrix.append(currentRow)
                            }
                        }.frame(maxWidth: UIScreen.main.bounds.width-8,  maxHeight: 333)
                    }
                }.task { await refresh() }
                
            }
            else{
                if self.checked{
                    //lobby is closed
                    Text("Sorry. Lobby is full")
                }
                else{
                    //still checking
                    Text("Connecting...")
                }
            }
            
        }.task {
            self.connected = await Datasource.shared.database!.joinLobby(game: lobbyName)
            if (self.connected){
                print("LOBBY OPEN")
                self.checked = true
                //self.gameSession(game: game)
                Datasource.shared.database!.gameSession(game: lobbyName)
            }
            else{
                print("lobby closed")
                self.checked = true
            }
        }
        
        
    }
    
    func refresh() async {//} async{
        do{
        try await Task.sleep(nanoseconds: 1000000000)
        
        //if !gameLogic.gameData.lastMove.isEmpty{
//        if gameLogic.gameData.winner != nil{
//            checkIfWin(colomn: gameLogic.gameData.lastMove[0] as! String, pos: Int(gameLogic.gameData.lastMove[1] as! String)!)
//        }
        
        if gameLogic.gameData.gameStarted{
            display = gameLogic.gameData.display
        }
        
        turn = gameLogic.gameData.turn
        board = gameLogic.gameData.board
    }
        catch{
            print("time error")
        }
    
    
    
    //backgrounds = gameLogic.gameData.backgrounds
        if gameLogic.gameData.winner == nil{
            await refresh()
        }
        else{
            turn = gameLogic.gameData.turn
            board = gameLogic.gameData.board
            
            checkIfWin(colomn: gameLogic.gameData.lastMove[0] as! String, pos: Int(gameLogic.gameData.lastMove[1] as! String)!)
        }
    
    //}
    //catch{
    //    print("error")
    }
    
    
    
    func checkIfWin(colomn: String, pos: Int){
        let colomns = ["colomn1","colomn2","colomn3","colomn4","colomn5","colomn6","colomn7"]
        let colomnPos = colomns.firstIndex(of: colomn)
        //print("colomn position\(colomnPos)")
        
        //resetBackground()
        //backgrounds[colomn]![pos] = Selected.yes
        
        var down:Int? = colomnPos
        
        var left:Int? = colomnPos
        var right:Int? = colomnPos
        
        var upLeft:Int? = colomnPos
        var upRight:Int? = colomnPos
        var downLeft:Int? = colomnPos
        var downRight:Int? = colomnPos
        
        var upDownCounter = 1
        var leftRightCounter = 1
        var uphillCounter = 1
        var downhillCounter = 1
        
        for step in 1...3{
            if (down == nil && left == nil && right == nil && upLeft == nil && upRight == nil && downLeft == nil && downRight == nil){
                //print("here?")
                break
            }
            
            //            print("down: \(down)")
            //
            //            print("left: \(left)")
            //            print("right: \(right)")
            //
            //            print("upleft: \(upLeft)")
            //            print("downright: \(downRight)")
            //            print("downleft: \(downLeft)")
            //            print("upright: \(upRight)")
            
            if (0...2).contains(pos) && down != nil{
                //check Vertical
                if Datasource.shared.board[colomn]![pos+step] == Datasource.shared.turn && down != nil{
                    
                    upDownCounter += 1
                }
                else{
                    down = nil
                }
            }
            else{
                down = nil
            }
            
            if left != nil || right != nil{
                //check Horizontal
                //right
                if (colomnPos! + step) <= (colomns.count-1) && right != nil{ //if not out on right
                    if Datasource.shared.board[colomns[colomnPos!+step]]![pos] == Datasource.shared.turn{
                        leftRightCounter += 1
                    }
                    else{
                        right = nil
                    }
                }
                else{
                    right = nil
                }
                
                //left
                
                if (colomnPos! - step) >= 0 && left != nil{
                    if Datasource.shared.board[colomns[colomnPos!-step]]![pos] == Datasource.shared.turn{
                        leftRightCounter += 1
                    }
                    else{
                        left = nil
                    }
                }
                else{
                    left = nil
                }
            }
            
            if upLeft != nil || upRight != nil || downLeft != nil || downRight != nil{
                //check Diagonal
                //right
                if (colomnPos! + step) <= (colomns.count-1){
                    //up
                    if (pos - step) >= 0 && upRight != nil{
                        if Datasource.shared.board[colomns[colomnPos! + step]]![pos - step] == Datasource.shared.turn{
                            uphillCounter += 1
                        }
                        else{
                            upRight = nil
                        }
                    }
                    else{
                        upRight = nil
                    }
                    
                    //down
                    
                    if (pos + step) <= (Datasource.shared.board[colomn]!.count-1) && downRight != nil{
                        if Datasource.shared.board[colomns[colomnPos! + step]]![pos + step] == Datasource.shared.turn{
                            downhillCounter += 1
                        }
                        else{
                            downRight = nil
                        }
                    }
                    else{
                        downRight = nil
                    }
                }
                
                //left
                if (colomnPos! - step) >= 0{
                    
                    //up
                    if (pos - step) >= 0 && upLeft != nil{
                        if Datasource.shared.board[colomns[colomnPos! - step]]![pos - step] == Datasource.shared.turn{
                            downhillCounter += 1
                        }
                        else{
                            upLeft = nil
                        }
                    }
                    else{
                        upLeft = nil
                    }
                    
                    //down
                    if (pos + step) <= (Datasource.shared.board[colomn]!.count-1) && downLeft != nil{
                        if Datasource.shared.board[colomns[colomnPos! - step]]![pos + step] == Datasource.shared.turn{
                            uphillCounter += 1
                        }
                        else{
                            downLeft = nil
                        }
                    }
                    else{
                        downLeft = nil
                    }
                }
            }
        }
        
        if upDownCounter >= 4{
            
            let winningPos = [(colomn, pos + 3), (colomn, pos + 2), (colomn, pos + 1), (colomn, pos)]
            for i in winningPos{
                Datasource.shared.backgrounds[i.0]![i.1] = Selected.yes
            }
            return
        }
        if leftRightCounter >= 4{
            
            var mostLeft = colomnPos!
            for step in (1...3){
                //not out of board
                if (colomnPos! - (step)) >= 0{
                    //if matrix[colomns[colomnPos!-(step)]]![pos] == turn{
                    if Datasource.shared.board[colomns[colomnPos!-(step)]]![pos] == Datasource.shared.turn{
                        mostLeft = colomnPos!-(step)
                    }
                    else{
                        break
                    }
                }
            }
            let winningPos = [(colomns[mostLeft], pos), (colomns[mostLeft+1], pos), (colomns[mostLeft+2], pos), (colomns[mostLeft+3], pos)] as [(String, Int)]
            
            for i in winningPos{
                Datasource.shared.backgrounds[i.0]![i.1] = Selected.yes
            }
            
            //winner = turn
            gameLogic.gameData.database!.gameOver(game: gameLogic.gameData.lobby!)
            return
        }
        if uphillCounter >= 4{
            //win diagonal
            //print("\(turn) Win diagonal (uphill)")
            
            var mostLeft = colomnPos!
            var mostDown = pos
            for step in (1...3){
                //not out of board
                //if (colomnPos! + (step)) <= matrix.count-1 && (pos - (step)) >= 0{
                if (colomnPos! + (step)) <= Datasource.shared.board.count-1 && (pos - (step)) >= 0{
                    //if matrix[colomns[colomnPos!+(step)]]![pos-(step)] == turn{
                    if Datasource.shared.board[colomns[colomnPos!+(step)]]![pos-(step)] == Datasource.shared.turn{
                        mostLeft = colomnPos!+(step)
                        mostDown = pos-(step)
                    }
                    else{
                        break
                    }
                }
            }
            let winningPos = [(colomns[mostLeft], mostDown), (colomns[mostLeft-1], mostDown+1), (colomns[mostLeft-2], mostDown+2), (colomns[mostLeft-3], mostDown+3)] as [(String, Int)]
            
            for i in winningPos{
                Datasource.shared.backgrounds[i.0]![i.1] = Selected.yes
            }
            
            //winner = turn
            gameLogic.gameData.database!.gameOver(game: gameLogic.gameData.lobby!)
            return
        }
        if downhillCounter >= 4{
            //win diagonal
            //print("\(turn) Win diagonal (downhill)")
            
            var mostRight = colomnPos!
            var mostDown = pos
            for step in (1...3){
                //not out of board
                if (colomnPos! - (step)) >= 0 && (pos - (step)) >= 0{
                    //if matrix[colomns[colomnPos!-(step)]]![pos-(step)] == turn{
                    if Datasource.shared.board[colomns[colomnPos!-(step)]]![pos-(step)] == Datasource.shared.turn{
                        mostRight = colomnPos!-(step)
                        mostDown = pos-(step)
                    }
                    else{
                        break
                    }
                }
            }
            let winningPos = [(colomns[mostRight], mostDown), (colomns[mostRight+1], mostDown+1), (colomns[mostRight+2], mostDown+2), (colomns[mostRight+3], mostDown+3)] as [(String, Int)]
            
            for i in winningPos{
                Datasource.shared.backgrounds[i.0]![i.1] = Selected.yes
            }
            
            //winner = turn
            gameLogic.gameData.database!.gameOver(game: gameLogic.gameData.lobby!)
            return
        }
        
        //showBoard()
        
        //turn.endTurn()
        
    }
    
    
    
    
}


//struct InGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        InGameView()
//    }
//}
