//
//  TankWorld.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

class TankWorld {
    var grid: [[GameObject?]]
    var turn: Int
    var gameOver = false
    var lastLivingTank:Tank?=nil
    var numberLivingTanks=0
    let numberCols,numberRows:Int
    
    // Other useful properties go here

    init(numberCols:Int,numberRows:Int) {
        self.numberCols=numberCols
        self.numberRows=numberRows
        grid = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)
        turn=1
        // other init stuff
    }

    func setWinner(lastTankStanding: Tank) {
        gameOver = true
        lastLivingTank = lastTankStanding
    }

    func populateTankWorld() {
        addGameObject(gameObject: SEND(row: 2, col: 2, name: "SEND", energy: Constants.initialTankEnergy, instructions: ""))
        addGameObject(gameObject: RCIV(row: 2, col: 3, name: "RCIV", energy: Constants.initialTankEnergy, instructions: ""))
        addGameObject(gameObject: SHLD(row: 7, col: 8, name: "SHLD", energy: Constants.initialTankEnergy, instructions: ""))
        addGameObject(gameObject: SCAN(row: 2, col: 5, name: "SCAN", energy: Constants.initialTankEnergy, instructions: ""))
        addGameObject(gameObject: MOVE(row: 3, col: 5, name: "SEND", energy: Constants.initialTankEnergy, instructions: ""))
        addGameObject(gameObject: RNDR(row: 10, col: 7, name: "RNDR", energy: Constants.initialTankEnergy, instructions: ""))
        addGameObject(gameObject: DIRR(row: 5, col: 7, name: "DIRR", energy: Constants.initialTankEnergy, instructions: ""))
        addGameObject(gameObject: MINE(row: 12, col: 12, name: "MINE", energy: Constants.initialTankEnergy, instructions: ""))
        addGameObject(gameObject: MISL(row: 5, col: 5, name: "MISL", energy: Constants.initialTankEnergy, instructions: ""))

    }

    func addGameObject(gameObject: GameObject) {
        logger.addMajorLog(gameObject, "Added to TankLand")
        if(grid[gameObject.position.row][gameObject.position.col] != nil){
            fatalError("Cannot add tank to taken spot")
        }
        grid[gameObject.position.row][gameObject.position.col] = gameObject

        if gameObject.objectType == .Tank { numberLivingTanks += 1 }
    }

    // One handle helper method for each action. Example:
    
    func handleRunRadar(tank: Tank) {
        guard let runRadarAction = tank.preActions[.RunRadar] else { return }
        actionRunRadar(tank: tank, runRadarAction: runRadarAction as! RunRadarAction)
    }
    func handleSendMessage(tank: Tank) {
        guard let sendMessageAction = tank.preActions[.SendMessage] else { return }
        actionSendMessage(tank: tank, sendMessageAction: sendMessageAction as! SendMessageAction)
    }
    func handleReceiveMessage(tank: Tank) {
        guard let receiveMessageAction = tank.preActions[.ReceiveMessage] else { return }
        actionReceiveMessage(tank: tank, receiveMessageAction: receiveMessageAction as! ReceiveMessageAction)
    }
    func handleSetShields(tank: Tank) {
        guard let setShieldsAction = tank.preActions[.SetShields] else { return }
        actionSetShields(tank: tank, setShieldsAction: setShieldsAction as! SetShieldsAction)
    }
    func handleDropMine(tank: Tank) {
        guard let dropMineAction = tank.postActions[.DropMineOrRover] as? DropMineAction else { return }
        
        actionDropMine(tank: tank, dropMineAction: dropMineAction)
    }
    func handleDropRover(tank: Tank) {
        guard let dropRoverAction = tank.postActions[.DropMineOrRover] as? DropRoverAction else { return }
        actionDropRover(tank: tank, dropRoverAction: dropRoverAction)
    }
    func handleFireMissile(tank: Tank) {
        guard let fireMissileAction = tank.postActions[.FireMissile] else { return }
        actionFireMissile(tank: tank, fireMissileAction: fireMissileAction as! FireMissileAction)
    }
    func handleMove(tank: Tank) {
        guard let moveAction = tank.postActions[.Move] else { return }
        actionMove(tank: tank, moveAction: moveAction as! MoveAction)
    }
   
    func checkWinner() -> Bool{
        var alive=0;
        for tank in findAllTanks(){
            if(isDead(tank)){
                fatalError("tank is dead but still in grid")
            }
            alive+=1;
        }
        if(alive==1){
            gameOver=true;
            lastLivingTank=findWinner()
            return(true)
        }
        return(false)
    }
    
    func doTurn() {
        for go in randomizeGameObjects(gameObjects: findAllGameObjects()){
            var cost:Int
            switch(go.objectType){
            case .Mine:
                cost=Constants.costLifeSupportMine
            case .Rover:
                cost=Constants.costLifeSupportRover
            case .Tank:
                cost=Constants.costLifeSupportTank

            }
            applyCost(go,amount: cost)
            if(isDead(go)){
                grid[go.position.row][go.position.col]=nil
                if(checkWinner()){
                    return;
                }
            }
        }
  
        for rover in randomizeGameObjects(gameObjects: findAllRovers()){
            let destination=Position(position: rover.position, direction: rover.givenDirection ?? getRandomDirection(), magnitude: 1)
            if(isValidPosition(destination)&&isEnergyAvailable(rover,amount: Constants.costOfMovingRover)){
                if let go=grid[destination.row][destination.col]{
                    dealMineDamage(rover, go)
                    logger.addLog(rover, "Moving rover hit \(go)")
                    if(isDead(go)){
                        grid[go.position.row][go.position.col]=nil
                        logger.addLog(rover, "Moving rover killed \(go)")

                        if(go.objectType == .Tank && checkWinner()){
                            return;
                        }
                    }
                }else{
                    applyCost(rover,amount: Constants.costOfMovingRover)
                    moveObject(rover, destination)
                }
            }
        }
        
        var tanks=findAllTanks()
        tanks = randomizeGameObjects(gameObjects: tanks)
        for tank in tanks{
            tank.computePreActions()
        }
        for tank in tanks {
            handleRunRadar(tank: tank)
        }
        MessageCenter.clear()
        for tank in tanks {
            handleSendMessage(tank: tank)
        }
        for tank in tanks {
            handleReceiveMessage(tank: tank)
        }
        for tank in tanks {
            handleSetShields(tank: tank)
        }
        tanks = randomizeGameObjects(gameObjects: tanks)
        for tank in tanks{
            tank.computePostActions()
        }
        for tank in tanks {
            handleDropMine(tank: tank)
            if(checkWinner()){
                return;
            }
            handleDropRover(tank: tank)
            if(checkWinner()){
                return;
            }
            handleFireMissile(tank: tank)
            if(checkWinner()){
                return;
            }
            handleMove(tank: tank)
            if(checkWinner()){
                return;
            }
        }
 
        turn += 1
    }
    
    func runOneTurn() {
        logger.print("Turn \(turn)")
        doTurn()
        logger.print(gridReport())
    }

    func driver() {
        populateTankWorld()
        logger.print(gridReport())
        while !gameOver {
            runOneTurn()
        }
        logger.print("****Winner is...\(lastLivingTank!)")
    }
}
