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
}
