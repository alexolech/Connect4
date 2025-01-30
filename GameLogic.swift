//
//  GameLogic.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-18.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

@MainActor
class GameLogic: ObservableObject{
    
    @Published var gameData = Datasource.shared
    @Published var openLobbies: [Lobby] = []
    
    var firestoreLinked = false
    
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
    
    @Published var turn: SlotState = SlotState.Red
    @Published var winner: SlotState? = nil
    @Published var display: String = "Player 1's turn"

    var pieceFalling = false
    var movesMade: Int = 0
    
    @Published var backgrounds = ["colomn1": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn2": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn3": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn4": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn5": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn6": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn7": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no]]
    
    var colomns = ["colomn1", "colomn2", "colomn3", "colomn4", "colomn5", "colomn6", "colomn7"]
    
    @Published var matrix: [String: [SlotState]] = ["row1": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row2": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row3": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row4": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row5": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row6": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row7": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty]]
    
    var upDownCounter = 1
    var leftRightCounter = 1
    
    var uphillCounter = 1
    var downhillCounter = 1
    
    var down:Int? = nil
    
    var left:Int? = nil
    var right:Int? = nil
    
    var upLeft:Int? = nil
    var upRight:Int? = nil
    var downLeft:Int? = nil
    var downRight:Int? = nil
    
    private func dropAnimation(_ row: String, _ pos: Int){
        pieceFalling = true
        let fallSpeed = 0.025
        var counter = 0
        for spot in (0...pos){
            counter += 1
                //fallSpeed += Double(spot)/Double(pos-spot)
                //((Double(spot+1))*fallSpeed)
                //print(fallSpeed * Double(counter))
                DispatchQueue.main.asyncAfter(deadline: .now() +  fallSpeed * Double(counter) ) {
                    
                    //gameLogic.matrix[row]![spot] = gameLogic.turn
                    Datasource.shared.board[row]![spot] = Datasource.shared.player
                    DispatchQueue.main.asyncAfter(deadline: .now() + (fallSpeed * Double(counter))/3 ) {
                        if spot == pos{
                            //print("Landed")
                            //gameLogic.matrix[row]![pos] = gameLogic.turn
                            
                            
                            self.checkIfWin(colomn: row, pos: pos)
                            
                            //display = "\(gameLogic.turn)'s turn"
                            //Datasource.shared.display = "Player \(Datasource.shared.player)'s turn"
                            
                            if self.movesMade >= 42{
                                self.display = "It's a Tie"
                                //gameLogic.turn = SlotState.Empty
                            }
                            
                            //if gameLogic.winner != nil{
                            if Datasource.shared.winner != nil{
                                //display = "\(gameLogic.winner!) Wins!"
                                self.display = "Player \(Datasource.shared.winner!) Wins!"
                            }
                            self.pieceFalling = false
                            self.gameData.madeMove = true
                            self.gameData.lastMove = [row, "\(pos)"]
                            self.database!.makeMove(game: self.gameData.lobby!)
                            print("done drop")
                            print(Datasource.shared.board)
                            return
                        }
                        
                        //gameLogic.matrix[row]![spot] = SlotState.Empty
                        Datasource.shared.board[row]![spot] = 0
                        
                    }
                }
            
            
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            // Put your code which should be executed with a delay here
//            for spot in (0..<pos){
//                gameLogic.matrix[row]![spot] = gameLogic.turn
//                gameLogic.matrix[row]![spot] = SlotState.Empty
//
//
//            }
//        }
        
    }
    
    func playTurn(row: String){
        //if gameLogic.winner == nil{
        if Datasource.shared.winner == nil{
            //if let i = gameLogic.matrix[row]!.lastIndex(of: SlotState.Empty) {
            if let i = Datasource.shared.board[row]!.lastIndex(of: 0) {
                dropAnimation(row, i)
                
                
//                else{
//                    //display = "\(gameLogic.turn)'s turn"
//                }
                //gameLogic.matrix[row]![i] = gameLogic.turn
                //gameLogic.checkIfWin(colomn: row, pos: i)
            }
        }
        
        
        
    }
    
    func reset(){
        
        matrix = ["row1": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row2": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row3": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row4": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row5": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row6": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row7": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty]]
        
        backgrounds = ["colomn1": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn2": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn3": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn4": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn5": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn6": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn7": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no]]
        
        turn = SlotState.Red
        
        winner = nil
        
        upDownCounter = 1
        leftRightCounter = 1
        
        uphillCounter = 1
        downhillCounter = 1
        
        movesMade = 0
    }
    
    func checkIfWin(colomn: String, pos: Int){
        
        movesMade += 1
        
        let colomnPos = colomns.firstIndex(of: colomn)
        //print("colomn position\(colomnPos)")
        
        //resetBackground()
        //backgrounds[colomn]![pos] = Selected.yes
        
        down = colomnPos
        
        left = colomnPos
        right = colomnPos
        
        upLeft = colomnPos
        upRight = colomnPos
        downLeft = colomnPos
        downRight = colomnPos
        
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
                checkVertical(step, colomn, pos)
            }
            else{
                down = nil
            }
            
            if left != nil || right != nil{
                checkHorizontal(step, colomn, pos, colomnPos!)
            }
            
            if upLeft != nil || upRight != nil || downLeft != nil || downRight != nil{
                checkDiagonal(step, colomn, pos, colomnPos!)
            }
//            print("step: \(step)")
//            print("vert: \(upDownCounter)")
//            print("horiz: \(leftRightCounter)")
//            print("uphill: \(uphillCounter)")
//            print("downhill: \(downhillCounter)")
        }
        
        if upDownCounter >= 4{
            //win vertical
            print("\(turn) Win vertical")
            
            
            //findVerticalLowSlot(colomn, pos) //3 under pos on colomn
            let winningPos = [(colomn, pos + 3), (colomn, pos + 2), (colomn, pos + 1), (colomn, pos)]
            for i in winningPos{
                backgrounds[i.0]![i.1] = Selected.yes
            }
            
            winner = turn
            gameData.database!.gameOver(game: gameData.lobby!)
            return
        }
        if leftRightCounter >= 4{
            //win horizontal
            print("\(turn) Win horizontal")
            
            var mostLeft = colomnPos!
            for step in (1...3){
                //not out of board
                if (colomnPos! - (step)) >= 0{
                    //if matrix[colomns[colomnPos!-(step)]]![pos] == turn{
                    if gameData.board[colomns[colomnPos!-(step)]]![pos] == gameData.turn{
                        mostLeft = colomnPos!-(step)
                    }
                    else{
                        break
                    }
                }
            }
            let winningPos = [(colomns[mostLeft], pos), (colomns[mostLeft+1], pos), (colomns[mostLeft+2], pos), (colomns[mostLeft+3], pos)] as [(String, Int)]
            
            for i in winningPos{
                backgrounds[i.0]![i.1] = Selected.yes
            }
            
            winner = turn
            gameData.database!.gameOver(game: gameData.lobby!)
            return
        }
        if uphillCounter >= 4{
            //win diagonal
            print("\(turn) Win diagonal (uphill)")
            
            var mostLeft = colomnPos!
            var mostDown = pos
            for step in (1...3){
                //not out of board
                //if (colomnPos! + (step)) <= matrix.count-1 && (pos - (step)) >= 0{
                if (colomnPos! + (step)) <= gameData.board.count-1 && (pos - (step)) >= 0{
                    //if matrix[colomns[colomnPos!+(step)]]![pos-(step)] == turn{
                    if gameData.board[colomns[colomnPos!+(step)]]![pos-(step)] == gameData.turn{
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
                backgrounds[i.0]![i.1] = Selected.yes
            }
            
            winner = turn
            gameData.database!.gameOver(game: gameData.lobby!)
            return
        }
        if downhillCounter >= 4{
            //win diagonal
            print("\(turn) Win diagonal (downhill)")
            
            var mostRight = colomnPos!
            var mostDown = pos
            for step in (1...3){
                //not out of board
                if (colomnPos! - (step)) >= 0 && (pos - (step)) >= 0{
                    //if matrix[colomns[colomnPos!-(step)]]![pos-(step)] == turn{
                    if gameData.board[colomns[colomnPos!-(step)]]![pos-(step)] == gameData.turn{
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
                backgrounds[i.0]![i.1] = Selected.yes
            }
            
            winner = turn
            gameData.database!.gameOver(game: gameData.lobby!)
            return
        }
    
    upDownCounter = 1
    leftRightCounter = 1
    
    uphillCounter = 1
    downhillCounter = 1
        
    //showBoard()
        
    turn.endTurn()
    //Datasource.shared.turn.endTurn()
        
    }
    
    func showBoard(){
        for i in 0..<6{
            print("\(matrix["row1"]![i].rawValue) \(matrix["row2"]![i].rawValue) \(matrix["row3"]![i].rawValue) \(matrix["row4"]![i].rawValue) \(matrix["row5"]![i].rawValue) \(matrix["row6"]![i].rawValue) \(matrix["row7"]![i].rawValue)")
        }
        
    }
    
    func resetBackground(){
        backgrounds = ["colomn1": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn2": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn3": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn4": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn5": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn6": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "colomn7": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no]]
    }

    private func checkVertical(_ step:Int, _ colomn:String, _ pos:Int){
        
        //only check down the colomn
        //print("step: \(step) = \(matrix[colomn]![pos+step])")
        //if matrix[colomn]![pos+step] == turn && down != nil{
        if gameData.board[colomn]![pos+step] == gameData.turn && down != nil{
            
            upDownCounter += 1
            
            //backgrounds[colomn]![pos+step] = Selected.yes
        }
        else{
            //upDownCounter = 1
            //print("noDown")
            down = nil
        }
    }
    
    private func findVeriticalLowSlot(_ colomn: String, _ pos: Int){
        //for
    }
    
    private func checkHorizontal(_ step:Int, _ colomn:String, _ pos:Int, _ colomnPos:Int){
        
        //right
        //print("right = \(colomnPos+step)")
        if (colomnPos + step) <= (colomns.count-1) && right != nil{ //if not out on right
//            print("step: \(step) = \(matrix[colomns[colomnPos+step]]![pos]), \(turn)")
//            print(matrix[colomns[colomnPos+step]]![pos] == turn)
            //if matrix[colomns[colomnPos+step]]![pos] == turn{
            if gameData.board[colomns[colomnPos+step]]![pos] == gameData.turn{
                leftRightCounter += 1
                
                //backgrounds[colomns[colomnPos+step]]![pos] = Selected.yes
            }
            else{
                //leftRightCounter = 1
                //print("noRight")
                right = nil
            }
        }
        //print(right)
        else{
            //print("noRight")
            right = nil
        }
        
        //left
        //print("left = \(colomnPos-step)")
        if (colomnPos - step) >= 0 && left != nil{
//            print("step: \(step) = \(matrix[colomns[colomnPos-step]]![pos]), \(turn)")
//            print(matrix[colomns[colomnPos-step]]![pos] == turn)
            //if matrix[colomns[colomnPos-step]]![pos] == turn{
            if gameData.board[colomns[colomnPos-step]]![pos] == gameData.turn{
                leftRightCounter += 1
                
                //backgrounds[colomns[colomnPos-step]]![pos] = Selected.yes
            }
            else{
                //leftRightCounter = 1
                //print("noLeft")
                left = nil
            }
        }
        //print(left)
        else{
            //print("noLeft")
            left = nil
        }
    }
    
    private func checkDiagonal(_ step:Int, _ colomn:String, _ pos:Int, _ colomnPos:Int){
        
        //right
        if (colomnPos + step) <= (colomns.count-1){
            //print("right up = \(colomnPos-step)")
            //up
            if (pos - step) >= 0 && upRight != nil{
                //if matrix[colomns[colomnPos + step]]![pos - step] == turn{
                if gameData.board[colomns[colomnPos + step]]![pos - step] == gameData.turn{
                    uphillCounter += 1
                    
                    //backgrounds[colomns[colomnPos + step]]![pos - step] = Selected.yes
                }
                else{
                    //uphillCounter = 1
                    //print("noUpRight")
                    upRight = nil
                }
            }
            else{
                //print("noUpRight")
                upRight = nil
            }
            
            //down
            //if (pos + step) <= (matrix[colomn]!.count-1) && downRight != nil{
            if (pos + step) <= (gameData.board[colomn]!.count-1) && downRight != nil{
                //if matrix[colomns[colomnPos + step]]![pos + step] == turn{
                //if matrix[colomns[colomnPos + step]]![pos + step] == turn{
                if gameData.board[colomns[colomnPos + step]]![pos + step] == gameData.turn{
                    downhillCounter += 1
                    
                    //backgrounds[colomns[colomnPos + step]]![pos + step] = Selected.yes
                }
                else{
                    //downhillCounter = 1
                    //print("noDownRight")
                    downRight = nil
                }
            }
            else{
                //print("noDownRight")
                downRight = nil
            }
//            print("\((pos + step) <= (matrix[colomn]!.count-1))")
        }
        
        //left
        if (colomnPos - step) >= 0{
            
            //up
            if (pos - step) >= 0 && upLeft != nil{
                //if matrix[colomns[colomnPos - step]]![pos - step] == turn{
                if gameData.board[colomns[colomnPos - step]]![pos - step] == gameData.turn{
                    downhillCounter += 1
                    
                    //backgrounds[colomns[colomnPos - step]]![pos - step] = Selected.yes
                }
                else{
                    //downhillCounter = 1
                    //print("noUpLeft")
                    upLeft = nil
                }
            }
            else{
                //print("noUpLeft")
                upLeft = nil
            }

            //down
            //if (pos + step) <= (matrix[colomn]!.count-1) && downLeft != nil{
            if (pos + step) <= (gameData.board[colomn]!.count-1) && downLeft != nil{
                //if matrix[colomns[colomnPos - step]]![pos + step] == turn{
                if gameData.board[colomns[colomnPos - step]]![pos + step] == gameData.turn{
                    uphillCounter += 1
                    
                    //backgrounds[colomns[colomnPos - step]]![pos + step] = Selected.yes
                }
                else{
                    //uphillCounter = 1
                    //print("noDownLeft")
                    downLeft = nil
                }
            }
            else{
                //print("noDownLeft")
                downLeft = nil
            }
        }
        
        
    }
    
}
