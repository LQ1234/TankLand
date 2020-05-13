//
//  Action.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
protocol Action: CustomStringConvertible {
    var action: Actions { get }

    var description: String { get }
}

protocol PreAction: Action {}

protocol PostAction: Action {}

struct SendMessageAction:PreAction {
    let action: Actions = .SendMessage
    let id:String
    let message:String
    var description: String {
        return "\(action) \(id) \(message)"
    }
    init (id:String,message:String){
        self.id=id
        self.message=message
    }
    
}
struct ReceiveMessageAction:PreAction {
    let action: Actions = .ReceiveMessage
    let id:String
    var description: String {
        return "\(action) \(id)"
    }
    init (id:String,text:String){
        self.id=id
    }
}
struct SetShieldsAction:PreAction{
    let action: Actions = .SetShields
    let shieldPower:Int
    var description: String {
        return "\(action) \(shieldPower)"
    }
    init (shieldPower:Int){
        self.shieldPower=shieldPower
    }
}
struct 
struct MoveAction: PostAction {
    let action: Actions = .Move
    let distance: Int
    let direction: Direction
    var description: String {
        return "\(action) \(distance) \(direction)"
    }

    init(distance: Int, direction: Direction) {
        self.distance = distance
        
        self.direction = direction
    }
}

//

import Foundation

enum Actions {
    case SendMessage
    case ReceiveMessage
    case SetShields
    case RunRadar
    case DropMine
    case DropRover
    case FireMissile
    case Move
}
