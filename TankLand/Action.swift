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
        return "\(action){id: \(id), message: \(message)}"
    }
    init (id:String,message:String){
        self.id=id
        self.message=message
    }
    var energyCostIfSucceeds:Int{
        return(Constants.costOfSendingMessage)
    }
    
}
struct ReceiveMessageAction:PreAction {
    let action: Actions = .ReceiveMessage
    let id:String
    var description: String {
        return "\(action){id: \(id)}"
    }
    init (id:String){
        self.id=id
    }
    var energyCostIfSucceeds:Int{
        return(Constants.costOfReceivingMessage)
    }
}
struct RunRadarAction:PreAction{
    let action: Actions = .RunRadar
    let radius: Int
    var description: String {
        return "\(action){radius: \(radius)}"
    }
    init (radius:Int){
        self.radius=radius
    }
    var energyCostIfSucceeds:Int{
        return(Constants.costOfRadarByUnitsDistance[self.radius])
    }
}
struct SetShieldsAction:PreAction{
    let action: Actions = .SetShields
    let energyGiven:Int
    var description: String {
        return "\(action){energyGiven: \(energyGiven)}"
    }
    init (energyGiven:Int){
        self.energyGiven=energyGiven
    }
    var energyCostIfSucceeds:Int{
        return(energyGiven)
    }
}

struct DropMineAction:PostAction{
    let action: Actions = .DropMineOrRover
    let energyGiven:Int
    let dropDirection:Direction
    var description: String {
        return "\(action){energyGiven: \(energyGiven), dropDirection: \(dropDirection)}"
    }
    init (energyGiven:Int,dropDirection:Direction){
        self.energyGiven=energyGiven
        self.dropDirection=dropDirection
    }
    var energyCostIfSucceeds:Int{
        return(Constants.costOfReleasingMine+self.energyGiven)
    }
}

struct DropRoverAction:PostAction{
    let action: Actions = .DropMineOrRover
    let energyGiven:Int
    let dropDirection:Direction
    let directionGiven:Direction?
    var description: String {
        return "\(action){energyGiven: \(energyGiven), dropDirection: \(dropDirection), directionGiven: \(directionGiven)}"
    }
    init (energyGiven:Int,dropDirection:Direction,directionGiven:Direction?){
        self.energyGiven=energyGiven
        self.dropDirection=dropDirection
        self.directionGiven=directionGiven
    }
    var energyCostIfSucceeds:Int{
        return(Constants.costOfReleasingRover+self.energyGiven)
    }
}
struct FireMissileAction: PostAction{
    let action: Actions = .FireMissile
    let energyGiven:Int
    let destination:Position
    var description: String {
        return "\(action){energyGiven: \(energyGiven), destination: \(destination)}"
    }
    init (energyGiven:Int,destination:Position){
        self.energyGiven=energyGiven
        self.destination=destination
    }

}
struct MoveAction: PostAction {
    let action: Actions = .Move
    let distance: Int
    let direction: Direction
    var description: String {
        return "\(action){distance: \(distance), direction: \(direction)}"
    }

    init(distance: Int, direction: Direction) {
        self.distance = distance
        
        self.direction = direction
    }
    var energyCostIfSucceeds:Int{
        return(Constants.costOfMovingTankPerUnitDistance[self.distance-1])
    }
}

//

import Foundation

enum Actions {
    case SendMessage
    case ReceiveMessage
    case SetShields
    case RunRadar
    case DropMineOrRover
    case FireMissile
    case Move
}
