//
//  Direction.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

enum Direction:Int {
    case North
    case NorthEast
    case East
    case SouthEast
    case South
    case SouthWest
    case West
    case NorthWest
    func asVec() -> Position{
        switch(self){
        case .North:
            return(Position(row:-1,col:0))
        case .NorthEast:
            return(Position(row:-1,col:1))
        case .East:
            return(Position(row:0,col:1))
        case .SouthEast:
            return(Position(row:1,col:1))
        case .South:
            return(Position(row:1,col:0))
        case .SouthWest:
            return(Position(row:1,col:-1))
        case .West:
            return(Position(row:0,col:-1))
        case .NorthWest:
            return(Position(row:-1,col:-1))
        }
    }
    static func random()->Direction{
        return(Direction(rawValue:Int.random(in: 0..<8))!)
    }
}
