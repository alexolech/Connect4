//
//  GameLogic.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-18.
//

import Foundation

class GameLogic: ObservableObject{
    
    @Published var turn: SlotState = SlotState.Red
    @Published var winner: SlotState? = nil
    
    var movesMade: Int = 0
    
    @Published var backgrounds: [String: [Selected]] = ["row1": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row2": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row3": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row4": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row5": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row6": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row7": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no]]
    
    var colomns = ["row1", "row2", "row3", "row4", "row5", "row6", "row7"]
    
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
    
    func reset(){
        
        matrix = ["row1": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row2": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row3": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row4": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row5": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row6": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty], "row7": [SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty,SlotState.Empty]]
        
        backgrounds = ["row1": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row2": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row3": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row4": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row5": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row6": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row7": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no]]
        
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
            return
        }
        if leftRightCounter >= 4{
            //win horizontal
            print("\(turn) Win horizontal")
            
            var mostLeft = colomnPos!
            for step in (1...3){
                //not out of board
                if (colomnPos! - (step)) >= 0{
                    if matrix[colomns[colomnPos!-(step)]]![pos] == turn{
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
            return
        }
        if uphillCounter >= 4{
            //win diagonal
            print("\(turn) Win diagonal (uphill)")
            
            var mostLeft = colomnPos!
            var mostDown = pos
            for step in (1...3){
                //not out of board
                if (colomnPos! + (step)) <= matrix.count-1 && (pos - (step)) >= 0{
                    if matrix[colomns[colomnPos!+(step)]]![pos-(step)] == turn{
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
                    if matrix[colomns[colomnPos!-(step)]]![pos-(step)] == turn{
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
            return
        }
    
    upDownCounter = 1
    leftRightCounter = 1
    
    uphillCounter = 1
    downhillCounter = 1
        
    //showBoard()
        
    turn.endTurn()
        
    }
    
    func showBoard(){
        for i in 0..<6{
            print("\(matrix["row1"]![i].rawValue) \(matrix["row2"]![i].rawValue) \(matrix["row3"]![i].rawValue) \(matrix["row4"]![i].rawValue) \(matrix["row5"]![i].rawValue) \(matrix["row6"]![i].rawValue) \(matrix["row7"]![i].rawValue)")
        }
        
    }
    
    func resetBackground(){
        backgrounds = ["row1": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row2": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row3": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row4": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row5": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row6": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no], "row7": [Selected.no,Selected.no,Selected.no,Selected.no,Selected.no,Selected.no]]
    }

    private func checkVertical(_ step:Int, _ colomn:String, _ pos:Int){
        
        //only check down the colomn
        //print("step: \(step) = \(matrix[colomn]![pos+step])")
        if matrix[colomn]![pos+step] == turn && down != nil{
            
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
            if matrix[colomns[colomnPos+step]]![pos] == turn{
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
            if matrix[colomns[colomnPos-step]]![pos] == turn{
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
                if matrix[colomns[colomnPos + step]]![pos - step] == turn{
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
            if (pos + step) <= (matrix[colomn]!.count-1) && downRight != nil{
                if matrix[colomns[colomnPos + step]]![pos + step] == turn{
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
                if matrix[colomns[colomnPos - step]]![pos - step] == turn{
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
            if (pos + step) <= (matrix[colomn]!.count-1) && downLeft != nil{
                if matrix[colomns[colomnPos - step]]![pos + step] == turn{
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
