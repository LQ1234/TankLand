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

    // Other useful properties go here

    init() {
        grid = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)
        // other init stuff
    }

    func setWinner(lastTankStanding: Tank) {
        gameOver = true
        lastLivingTank = lastTankStanding
    }

    func populateTankWorld() {
        // Sample
        addGameObject(gameObject: JTank5(row: 2, col: 2, name: "T1", energy: 20000, id: "J1", instructions: ""))

        addGameObject(gameObject: JTank4(row: 7, col: 2, name: "T2", energy: 20000, id: "J2", instructions: ""))

        addGameObject(gameObject: JTank4(row: 7, col: 3, name: "T2", energy: 10000, id: "J3", instructions: ""))

        // addGameObject( gameObject: JTank(row: 7, col: 5,  name: "T5", energy: 8000, id: "J3", instructions: ""))

        // addGameObject( gameObject: JTank(row: 12, col: 3,  name: "T6", energy: 7000, id: "J4", instructions: ""))
    }

    func addGameObject(gameObject: GameObject) {
        logger.addMajorLog(gameObject, "Added to TankLand")

        grid[gameObject.position.row][gameObject.position.col] = gameObject

        if gameObject.objectType == .Tank { numberLivingTanks += 1 }
    }

    // One handle helper method for each action. Example:

    func handleRadar(tank: Tank) {
        guard let radarAction = tank.preActions[.Radar] else { return }
        actionRunRadar(tank: tank, radarAction: radarAction as! RadarAction)
    }

    func doTurn() {
        var allObjects = findAllGameObjects()
        allObjects = randomizeGameObjects(gameObjects: allObjects)

        // all the code needed to run a single turn goes here
        // many for loops as discussed in class

        turn += 1
    }

    func runOneTurn() {
        doTurn()
        print(gridReport())
    }

    func driver() {
        populateTankWorld()
        print(gridReport())
        while !gameOver {
            // This while loop is the driver for TankLand
        }
        print("****Winner is...\(lastLivingTank!)")
    }
}
