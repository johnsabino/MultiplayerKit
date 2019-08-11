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

class MenuScene: MPMenuScene {
    var startButton: ButtonNode!
    
    override func authenticationChanged(_ notification: Notification) {
        if let isConnected = notification.object as? Bool {
            self.startButton.isEnabled = isConnected
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupButtons()
    }
    
    func setupButtons() {
        self.startButton = ButtonNode(text: "START GAME")
        self.startButton.position.y = -30
        self.startButton.actionBlock = {
            GameCenterService.shared.presentMatchMaker()
        }
        
        addChild(startButton)
    }
}
