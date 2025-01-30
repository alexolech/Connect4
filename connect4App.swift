//
//  connect4App.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-18.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      //Datasource.shared.firebaseLinked = true
      Datalink.shared.firebaseLinked = true
      //print("here")
      //Datasource.shared.database?.add10Lobies()
    return true
  }
}

@main
struct connect4App: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var gameLogic:GameLogic = GameLogic()
    
    
    
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            //LocalGameView().environmentObject(gameLogic)
        
            LobbySelectView().environmentObject(gameLogic)
        }
    }
}
