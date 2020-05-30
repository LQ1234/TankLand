//
//  Mine.swift
//  TankLand
//
//  Created by larry qiu on 5/14/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
class Mine:GameObject{
    let givenDirection: Direction?
    init(row: Int, col: Int, givenEnergy: Int, id: String) {
        givenDirection=nil
        super.init(row: row, col: col, objectType: .Mine, energy: givenEnergy, id: id)
    }
    init(row: Int, col: Int, givenEnergy: Int, givenDirection:Direction?, id: String) {
        self.givenDirection=givenDirection
        super.init(row: row, col: col, objectType: .Rover, energy: givenEnergy, id: id)
    }
}
