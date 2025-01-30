//
//  LobbySelectView.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-23.
//

import SwiftUI

struct LobbySelectView: View {
    
    @State var openLobbies: [Lobby] = []
    //@ObservedObject var gameLogic:GameLogic
    @EnvironmentObject var gameLogic:GameLogic
    
    @State var username: String = ""
    
    //@Binding var data: Datasource

    
    var body: some View {
        //NavigationView{
        //NavigationView{
        
//        if self.gameLogic.gameData.lobbies.didSet{
//            Button(action: {
//                self.openLobbies = gameLogic.gameData.lobbies
//            }){
//                Text("|")
//                Text("V")
//            }
//
//
//        }
        NavigationView{
            VStack{
                Button(action:{
                    
                    print(Datasource.shared.lobbies.count)
                    //print(self.openLobbies)
                    //self.openLobbies.append(Lobby(name: "String", isOpen: true, player1: "", player2: "", turn: 1, isFinished: false))
                    //self.openLobbies = self.gameLogic.gameData.lobbies
                    //print(self.openLobbies)
                    self.openLobbies = gameLogic.gameData.lobbies
                }){
                    Text("Update")
                    Text("\(Datasource.shared.lobbies.count)")
                }
                
                if (self.openLobbies.isEmpty) || UserDefaults.standard.string(forKey: "username") == nil{
                    Text("Empty")
                    //will have to make sure that usernames are not repeated
                    TextField("Enter username", text: self.$username)
                    Button(action: {
                        if self.username != ""{
                            UserDefaults.standard.set(self.username, forKey: "username")
                        }
                    }){
                        Text("Pick Name")
                    }

                }
                else{
                    List{
                        ForEach(self.openLobbies, id: \.id) { lobby in
                            //ForEach(gameLogic.gameData.lobbies, id: \.id) { lobby in
                            //ForEach(Datasource.shared.lobbies, id: \.id) { lobby in
                            NavigationLink(destination: InGameView(lobbyName: lobby)){
                                ZStack{
                                    Rectangle().foregroundColor(Color.gray).frame(width: 200, height: 200)
                                    Text("\(lobby.name)").font(.title).foregroundColor(Color.black)
                                }//.onTapGesture {print("pressed \(lobby.name)")}
                            }
                            
                        }
                        
                    }
                }
                
                
                
                //        }.onAppear(perform: {
                //            gameLogic.database!.getOpenLobbies()
                //        })
                //
                //        .onChange(of: self.gameLogic.gameData.lobbies, perform: { newValue in
                //            self.openLobbies = newValue
                //        })
                
                
            }.onAppear(perform: {
                
                //gameLogic.database!.getOpenLobbies()
                Task {
                    print(#function)
                    self.setValues()
                }
                
            }).task {
                do{
                    print("in tesk")
                    try await Task.sleep(nanoseconds: 1500000000)
                    print("after wait")
                    self.openLobbies = gameLogic.gameData.lobbies
                    //self.openLobbies = gameLogic.gameData.lobbies
                    print(self.openLobbies)
                }
                catch{
                    print("error")
                }
                
                //Task.sleep(until: InstantProtocol, clock: <#T##Clock#>)
            }
            
        }


            
        
    }
    
    func setValues(){
        gameLogic.database!.getOpenLobbies()
        print(self.gameLogic.gameData.lobbies)
        print(gameLogic.database!.db)
        //self.openLobbies.append(Lobby(name: "String", isOpen: true, player1: "", player2: "", turn: 1, isFinished: false))
    }
    
}

//struct LobbySelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        LobbySelectView()
//    }
//}
