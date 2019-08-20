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

/*OBS: a cena do menu deve herdar de MPMenuScene
 pois não pode ser um protocolo. Já a GameScene(Multiplayer) pode ser um protocolo,
pois tanto uma cena 2d quanto 3d podem implementa-lo */
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
            self.presentMatchMaker()
        }
        addChild(startButton)
        
        //TrainingButton
        trainingButton = ButtonNode(text: "TRAINING MODE")
        trainingButton.isEnabled = true
        trainingButton.position.y = -100
        trainingButton.actionBlock = {
            guard let view = self.view else {return}
            let gameScene = GameScene(size: view.frame.size)
            gameScene.isTraining = true
            gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            gameScene.scaleMode = .resizeFill
            gameScene.view?.showsPhysics = true
            gameScene.view?.ignoresSiblingOrder = true
            
            // Present the scene
            view.presentScene(gameScene, transition: .crossFade(withDuration: 1.0))
        }
        addChild(trainingButton)
    }
}
