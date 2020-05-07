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

struct MoveAction: PostAction {
    let action: Actions

    let distance: Int

    let direction: Direction

    var description: String {
        return "\(action) \(distance) \(direction)"
    }

    init(distance: Int, direction: Direction) {
        action = .Move

        self.distance = distance

        self.direction = direction
    }
}

//

import Foundation

enum Actions {
    case Move
}
