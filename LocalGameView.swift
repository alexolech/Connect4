//
//  LocalGameView.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-18.
//

import SwiftUI

extension SlotState{
    func toColor() -> Color{
        switch self{
        case .Red:
            return Color.red
        case .Yellow:
            return Color.yellow
        default:
            return Color.blue
        }
    }
}

extension Selected{
    func toColor() -> Color{
        switch self{
        case .yes:
            return Color.green
        default:
            return Color.cyan
        }
    }
}

struct LocalGameView: View {
    
    @EnvironmentObject var gameLogic:GameLogic

    @State private var display: String = "Red's turn"
    
    @State private var across: Bool = false
    
    @State private var pieceFalling = false
    
    
    var body: some View {
        VStack{
            Text("Connect 4 to win").font(.title).padding(20)
            Text(display).font(.title2).foregroundColor(gameLogic.turn.toColor())
            VStack{
                HStack{
                    ForEach(1..<8) { row in
                        VStack{
                            //self.currentRow = []
                            ForEach(0..<6) { line in
        
                                Button(action: {
                                    
                                    if (!pieceFalling){
                                        playTurn(row: "row\(row)")
                                    }
                                    
                                    //matrix["row\(row)"]?[line] = SlotState.Red
                                    //print("row \(row), line \(line)")
                                })
                                {
                                    //slot =
                                    Text("O").foregroundColor(gameLogic.matrix["row\(row)"]?[line].toColor())
                                    .font(.title).bold().frame(maxWidth: UIScreen.main.bounds.width/8.75, maxHeight: UIScreen.main.bounds.width/8.75 ).background(gameLogic.backgrounds["row\(row)"]?[line].toColor())}
                                    //currentRow.append(slot)
                            }
                        }
                        //self.matrix.append(currentRow)
                    }
                }.frame(maxWidth: UIScreen.main.bounds.width-8,  maxHeight: 333)
                
//                HStack{
//                    Button(action: {
//
//                        turn = playTurn(row: "row1", turn: turn)
//
//                        print("pressed 1")
//                    })
//                    {
//                        Text("Row 1").overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.blue, lineWidth: 1))
//                    }
//                    Button(action: {
//
//                        turn = playTurn(row: "row2", turn: turn)
//                        print("pressed 2")
//                    })
//                    {
//                        Text("Row 2").overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.blue, lineWidth: 1))
//                    }
//                    Button(action: {
//
//                        turn = playTurn(row: "row3", turn: turn)
//                        print("pressed 3")
//                    })
//                    {
//                        Text("Row 3").overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.blue, lineWidth: 1))
//                    }
//                    Button(action: {
//
//                        turn = playTurn(row: "row4", turn: turn)
//                        print("pressed 4")
//                    })
//                    {
//                        Text("Row 4").overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.blue, lineWidth: 1))
//                    }
//                    Button(action: {
//
//                        turn = playTurn(row: "row5", turn: turn)
//                        print("pressed 5")
//                    })
//                    {
//                        Text("Row 5").overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.blue, lineWidth: 1))
//                    }
//                    Button(action: {
//
//                        turn = playTurn(row: "row6", turn: turn)
//                        print("pressed 6")
//                    })
//                    {
//                        Text("Row 6").overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.blue, lineWidth: 1))
//                    }
//                    Button(action: {
//
//                        turn = playTurn(row: "row7", turn: turn)
//                        print("pressed 7")
//                    })
//                    {
//                        Text("Row 7").frame(minWidth: 50, minHeight: 50)
//                    }
//                }.background(Color.white)
                
            }.background(Color.blue)
            
            Button(action: {
                gameLogic.reset()
                display = "Red's Turn"
            }){
                Text("Reset Game").font(.title)
            }.padding(20)
            Toggle("Playing across table", isOn: self.$across).padding(.leading,50).padding(.trailing,50)
        }.rotationEffect(Angle(degrees: Double(( ( (self.across ? 1: 0 ) * 360) / gameLogic.turn.rawValue)))) //maybe not good
        
        
    }
    
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
                    gameLogic.matrix[row]![spot] = gameLogic.turn
                    DispatchQueue.main.asyncAfter(deadline: .now() + (fallSpeed * Double(counter))/3 ) {
                        if spot == pos{
                            //print("Landed")
                            //gameLogic.matrix[row]![pos] = gameLogic.turn
                            gameLogic.checkIfWin(colomn: row, pos: pos)
                            display = "\(gameLogic.turn)'s turn"
                            if gameLogic.movesMade >= 42{
                                display = "It's a Tie"
                                //gameLogic.turn = SlotState.Empty
                            }
                            
                            if gameLogic.winner != nil{
                                display = "\(gameLogic.winner!) Wins!"
                            }
                            pieceFalling = false
                            return
                        }
                        gameLogic.matrix[row]![spot] = SlotState.Empty
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
        if gameLogic.winner == nil{
            if let i = gameLogic.matrix[row]!.lastIndex(of: SlotState.Empty) {
                dropAnimation(row, i)
                
                
//                else{
//                    //display = "\(gameLogic.turn)'s turn"
//                }
                //gameLogic.matrix[row]![i] = gameLogic.turn
                //gameLogic.checkIfWin(colomn: row, pos: i)
            }
        }
        
        
        
    }
}

struct LocalGameView_Previews: PreviewProvider {
    static var previews: some View {
        LocalGameView()
    }
}
