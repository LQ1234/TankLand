//
//  main.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

class LTank: Tank{
    override func computePreActions() {
        
        let scan=RunRadarAction(radius: 4)
        addPreAction(preAction:scan)
        
        addPreAction(preAction:SendMessageAction(id: "String", message: "asp"))
        addPreAction(preAction:ReceiveMessageAction(id: "String"))
        addPreAction(preAction: SetShieldsAction(energyGiven: 500))
    }

    override func computePostActions() {
        print("\(self.id) radar results: \(self.radarResults)")
        let moveAction=MoveAction(distance: 2, direction: getRandomDirection())
        addPostAction(postAction: moveAction)
        if let pos=self.radarResults?.first?.position{
            let mis=FireMissileAction(energyGiven: 1000, destination: pos)
            addPostAction(postAction: mis)

        }
        if(Bool.random()){
            let drop=DropMineAction(energyGiven: 1000, dropDirection: getRandomDirection())
            addPostAction(postAction: drop)

        }else{
            let drop=DropRoverAction(energyGiven: 1000, dropDirection: getRandomDirection(), directionGiven: Bool.random() ? getRandomDirection() : nil)
            addPostAction(postAction: drop)
        }
        
    }
}
while(true){
    let k=TankWorld(numberCols: 15, numberRows: 15);

    k.populateTankWorld()
    k.driver();
}
