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
    let name: String
    private (set) var energy: Int
    let id: String
    private (set) var position: Position


    init(row: Int, col: Int, objectType: GameObjectType, name: String, energy: Int, id: String){
        self.objectType = objectType
        self.name = name
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
        return "\(objectType) \(name) \(energy) \(id) \(position)"
    }

}
