//
//  MenuScene.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit
import MultiplayerKit

//OBS: a cena do menu deve herdar de MPMenuScene
class MenuScene: MPMenuScene {
    
    var startButton: ButtonNode!
    var trainingButton: ButtonNode!
    
    override func authenticationChanged(_ notification: Notification) {
        if let isConnected = notification.object as? Bool {
            startButton.isEnabled = isConnected
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupButtons()
    }
    
    func setupButtons() {
        //StartButton
        startButton = ButtonNode(text: "START GAME")
        startButton.position.y = -30
        startButton.actionBlock = {
            GameCenterService.shared.presentMatchMaker()
        }
        addChild(startButton)
        
        //TrainingButton
        trainingButton = ButtonNode(text: "TRAINING MODE")
        trainingButton.isEnabled = true
        trainingButton.position.y = -100
        trainingButton.actionBlock = {
            GameCenterService.shared.startGame(match: GKMatch())
        }
        addChild(trainingButton)
    }
}
