//
//  TankWorldActions.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

extension TankWorld {
    // put the code to to run actions in this file. A few sample actions are given
    func actionRunRadar(tank:Tank,runRadarAction:RunRadarAction){
        if isDead(tank) { return }
        
        logger.addLog(tank, "Running Radar \(runRadarAction)")

        if !isEnergyAvailable(tank, amount: runRadarAction.energyCostIfSucceeds) {
            logger.addLog(tank, "Insufficient energy to run radar")
            return
        }
        
        applyCost(tank, amount: runRadarAction.energyCostIfSucceeds)
        var radarResults:[RadarResult]=[]
        for p in findGameObjectsWithinRange(tank.position, range: runRadarAction.radius){
            radarResults.append(RadarResult(position: p, energy: grid[p.row][p.col]!.energy, id: grid[p.row][p.col]!.id))
        }
        tank.setRadarResult(radarResults:radarResults )
    }
    
    func actionSendMessage(tank: Tank, sendMessageAction: SendMessageAction) {
        if isDead(tank) { return }

        logger.addLog(tank, "Sending Message \(sendMessageAction)")

        if !isEnergyAvailable(tank, amount: Constants.costOfSendingMessage) {
            logger.addLog(tank, "Insufficient energy to send message")
            return
        }

        applyCost(tank, amount: Constants.costOfSendingMessage)

        MessageCenter.sendMessage(id: sendMessageAction.id, message: sendMessageAction.message)
    }

    func actionReceiveMessage(tank: Tank, receiveMessageAction: ReceiveMessageAction) {
        if isDead(tank) { return }

        logger.addLog(tank, "Receiving Message \(receiveMessageAction)")

        if !isEnergyAvailable(tank, amount: Constants.costOfReceivingMessage) {
            logger.addLog(tank, "Insufficient energy to recieve message")
            return
        }

        applyCost(tank, amount: Constants.costOfReceivingMessage)

        let message = MessageCenter.receiveMessage(id: receiveMessageAction.id)

        tank.setReceivedMessage(receivedMessage: message)
    }
    
    func actionSetShields(tank: Tank, setShieldsAction: SetShieldsAction) {
        if isDead(tank) { return }

        logger.addLog(tank, "Setting shields \(setShieldsAction)")

        if !isEnergyAvailable(tank, amount: setShieldsAction.energyCostIfSucceeds) {
            logger.addLog(tank, "Insufficient energy to set shields")
            return
        }

        applyCost(tank, amount: setShieldsAction.energyCostIfSucceeds)
        tank.setShields(amount: setShieldsAction.energyGiven*Constants.shieldPowerMultiple)
        
    }
    func actionDropMine(tank: Tank,dropMineAction:DropMineAction){
        if isDead(tank) { return }
        logger.addLog(tank, "Dropping Mine \(dropMineAction)")
        if !isEnergyAvailable(tank, amount: dropMineAction.energyCostIfSucceeds) {
            logger.addLog(tank, "Insufficient energy to drop mine")
            return
        }
        let dropLocation=Position(position: tank.position, direction: dropMineAction.dropDirection, magnitude: 1)
        if(!isPositionEmpty(dropLocation)){
            logger.addLog(tank, "Drop mine location taken/is out of bounds")
            return
        }
        applyCost(tank, amount: dropMineAction.energyCostIfSucceeds)
        let mine=Mine(row: dropLocation.row, col: dropLocation.col, givenEnergy: dropMineAction.energyGiven, id: "Mine of \(tank.id)")
        grid[dropLocation.row][dropLocation.col]=mine
    }
    
    func actionDropRover(tank: Tank,dropRoverAction:DropRoverAction){
        if isDead(tank) { return }
        logger.addLog(tank, "Dropping Rover \(dropRoverAction)")
        if !isEnergyAvailable(tank, amount: dropRoverAction.energyCostIfSucceeds) {
            logger.addLog(tank, "Insufficient energy to drop rover")
            return
        }
        let dropLocation=Position(position: tank.position, direction: dropRoverAction.dropDirection, magnitude: 1)
        if(!isPositionEmpty(dropLocation)){
            logger.addLog(tank, "Drop rover location taken/is out of bounds")
            return
        }
        applyCost(tank, amount: dropRoverAction.energyCostIfSucceeds)
        let rover=Mine(row: dropLocation.row, col: dropLocation.col, givenEnergy: dropRoverAction.energyGiven, givenDirection: dropRoverAction.directionGiven, id: "Rover of \(tank.id)")
        grid[dropLocation.row][dropLocation.col]=rover
    }
    func actionFireMissile(tank: Tank,fireMissileAction:FireMissileAction){
        if isDead(tank) { return }
        logger.addLog(tank, "Firing Missile \(fireMissileAction)")
        if(!isValidPosition(fireMissileAction.destination)){
            logger.addLog(tank, "Missile Destination Invalid.")
            return
        }
        let cost=fireMissileAction.energyGiven+Constants.costOfLaunchingMissle + Int(Float(Constants.costOfFlyingMissilePerUnitDistance)*sqrt(Float(Position.distancesq(tank.position,fireMissileAction.destination))))

        if !isEnergyAvailable(tank, amount: cost) {
            logger.addLog(tank, "Insufficient energy to fire missile")
            return
        }
        applyCost(tank, amount: cost)
        
        logger.addLog(tank, "MISSLE STRIKE RESULTS")
        func deal(_ dmg:Int,_ go:GameObject){
            let dmg=fireMissileAction.energyGiven*Constants.missleStrikeMultiple
            applyCost(go, amount: dmg)

            logger.addLog(tank, "Struck \(go), dealt \(dmg)")
            
            if(isDead(go)){
                logger.addLog(go, "Has died")
                grid[go.position.row][go.position.col]=nil
                if(go.objectType == .Tank){
                    let transfered=(go.energy+dmg)/Constants.missleStrikeEnergyTransferFraction

                    if(isDead(tank)){
                        logger.addLog(tank, "was going to get \(transfered) energy from destroyed tank, but is dead.")
                        return;

                    }
                    logger.addLog(tank, "got \(transfered) energy from destroyed tank.")
                    tank.addEnergy(amount: transfered)

                }
            }
        }
        if let go=grid[fireMissileAction.destination.row][fireMissileAction.destination.col]{
            let dmg=fireMissileAction.energyGiven*Constants.missleStrikeMultiple
            deal(dmg,go)
            if(checkWinner()){
                return;
            }
        }else{
            logger.addLog(tank, "\(fireMissileAction.destination) empty.")

        }

        for pos in getLegalSurroundingPositions(fireMissileAction.destination){
            if let go=grid[pos.row][pos.col]{
                let dmg=fireMissileAction.energyGiven*Constants.missleStrikeMultipleCollateral
                deal(dmg,go)
                if(checkWinner()){
                    return;
                }
            }else{
                logger.addLog(tank, "\(pos) empty.")

            }
        }
        logger.addLog(tank, "END MISSLE STRIKE RESULTS")

    }
    
    func actionMove(tank: Tank, moveAction:MoveAction){
        if isDead(tank) { return }
        precondition(grid[tank.position.row][tank.position.col] === tank)

        logger.addLog(tank, "Moving \(moveAction)")
        if !isEnergyAvailable(tank, amount: moveAction.energyCostIfSucceeds) {
            logger.addLog(tank, "Insufficient energy to move")
            return
        }
        let destination = Position(position: tank.position, direction: moveAction.direction, magnitude: moveAction.distance)
        if(!isValidPosition(destination)){
            logger.addLog(tank, "Invalid move destination")
            return
        }
        
        if(grid[destination.row][destination.col]?.objectType == .Tank){
            logger.addLog(tank, "Move destination is taken by tank.")
            return
        }
        
        applyCost(tank, amount: moveAction.energyCostIfSucceeds)
        
        if let go = grid[destination.row][destination.col] {
            let mine=go as! Mine
            dealMineDamage(mine, tank)
            logger.addLog(tank, "Tank stepped on mine.")
            if(isDead(tank)){
                grid[tank.position.row][tank.position.col]=nil
                logger.addLog(tank, "Tank destroyed by mine.")
                if(checkWinner()){
                    return;
                }
                return
            }
        }
        moveObject(tank, destination)
    }
}
