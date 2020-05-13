//
//  GameObject.swift
//  TankLand
//
//  Created by larry qiu on 5/6/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

class GameObject: CustomStringConvertible{
    let objectType: GameObjectType
    private (set) var energy: Int
    let id: String
    private (set) var position: Position


    init(row: Int, col: Int, objectType: GameObjectType, energy: Int, id: String){
        self.objectType = objectType
        self.energy = energy
        self.id = id
        self.position = Position(row: row, col: col)
    }


    final func addEnergy(amount: Int){
        energy += amount
    }

    
    final func useEnergy(amount: Int){
        energy = (amount > energy) ? 0 : energy - amount
    }
    

    final func setPosition(newPosition: Position){
        position = newPosition
    }

 

    var description: String{
        return "\(objectType) \(energy) \(id) \(position)"
    }

}
