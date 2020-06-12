//
//   Tank.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

class Tank: GameObject {
    private(set) var shields: Int = 0
    private(set) var radarResults: [RadarResult]?
    private(set) var receivedMessage: String?
    private(set) var preActions = [Actions: PreAction]()
    private(set) var postActions = [Actions: PostAction]()
    private let initialInstructions: String?

    init(row: Int, col: Int, name: String, energy: Int, instructions: String) {
        initialInstructions = instructions

        super.init(row: row, col: col, objectType: .Tank, energy: energy, id: name)
    }

    final func clearActions() {
        preActions = [Actions: PreAction]()

        postActions = [Actions: PostAction]()
    }

    final func receiveMessage(message: String?) { receivedMessage = message }

    func computePreActions() {}

    func computePostActions() {}

    final func addPreAction(preAction: PreAction) {
        preActions[preAction.action] = preAction
    }

    final func addPostAction(postAction: PostAction) {
        postActions[postAction.action] = postAction
    }

    final func setShields(amount: Int) {
        shields = amount
    }

    final func setRadarResult(radarResults: [RadarResult]!) {
        self.radarResults = radarResults
    }

    final func setReceivedMessage(receivedMessage: String?) {
        
        self.receivedMessage = receivedMessage ?? ""
    }
}
