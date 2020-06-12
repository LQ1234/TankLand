//
//  main.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

class SEND: Tank{
    override func computePreActions() {
        addPreAction(preAction:SendMessageAction(id: "SEND's ID", message: "hello this is SEND's message"))
    }
}
class RCIV: Tank{
    override func computePreActions() {
        addPreAction(preAction:ReceiveMessageAction(id:"SEND's ID"))
    }
    override func computePostActions() {
        print("RCIV recieved \(receivedMessage)")
    }
}
class SHLD: Tank{
    override func computePreActions() {
       addPreAction(preAction: SetShieldsAction(energyGiven: 500))
    }
}
class SCAN: Tank{
    override func computePreActions() {
       addPreAction(preAction:RunRadarAction(radius: 5))
    }
    override func computePostActions() {
        print("SCAN's Scan results: \(radarResults)")
    }
}
class MOVE: Tank{
    override func computePostActions() {
        addPostAction(postAction: MoveAction(distance: 2, direction: getRandomDirection()))
    }
}
class RNDR: Tank{
    override func computePostActions() {
        addPostAction(postAction: DropRoverAction(energyGiven: 10000, dropDirection: .SouthEast, directionGiven:nil))
    }
}
class DIRR: Tank{
    override func computePostActions() {
        addPostAction(postAction: DropRoverAction(energyGiven: 10000, dropDirection: .North, directionGiven:.North))
    }
}
class MINE: Tank{
    override func computePostActions() {
        addPostAction(postAction: DropMineAction(energyGiven: 10000, dropDirection: .North))
    }
}
class MISL: Tank{
    override func computePostActions() {
        addPostAction(postAction: FireMissileAction(energyGiven: 1000, destination: Position(row: 7,col: 7)))
    }
}

let k=TankWorld(numberCols: 15, numberRows: 15);

k.driver();
