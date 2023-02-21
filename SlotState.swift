//
//  SlotState.swift
//  connect4
//
//  Created by Alex Olechnowicz on 2023-02-18.
//

import Foundation

enum SlotState: Int{
    
    case Empty = 0
    case Red = 1
    case Yellow = 2
    
    mutating func endTurn(){
        switch self{
        case .Red:
            self = .Yellow
        case .Yellow:
            self = .Red
        default: break
        }
    }
}

enum Selected: Int{
    case yes = 1
    case no = 0
    
    mutating func toggle(){
        switch self{
        case .yes:
            self = .no
        case .no:
            self = .yes
        }
    }
}

