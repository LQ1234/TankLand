//
//  Position.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

struct Position:Hashable {
    var row:Int
    var col:Int
    init(row: Int, col: Int){
        self.row=row
        self.col=col
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }
}
