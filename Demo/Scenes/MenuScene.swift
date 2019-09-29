//
//  MenuScene.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import MultiplayerKit
/** Deve ser final class por conta do protocolo MenuSceneProtocol*/
final class MenuScene: SKScene, MKMenuScene {
    var matchmaker: Matchmaker?
    
    var startButton: ButtonNode!
    var trainingButton: ButtonNode!
    
    func didAuthenticationChanged(to state: Matchmaker.AuthenticationState) {
        startButton.isEnabled = state == .authenticated ? true : false
    }
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        setupButtons()
    }
    
    func setupButtons() {
        //StartButton
        startButton = ButtonNode(text: "START GAME")
        startButton.position.y = -30
        addChild(startButton)

        //TrainingButton
        trainingButton = ButtonNode(text: "TRAINING MODE")
        trainingButton.isEnabled = true
        trainingButton.position.y = -100
        addChild(trainingButton)
        
        startButton.actionBlock = presentMatchMaker
        trainingButton.actionBlock = startTraining
    }
    
    func willStartGame() {
        // Present the scene
        view?.presentScene(GameScene(), transition: SKTransition.crossFade(withDuration: 1.0))
    }
    
    func startTraining() {
        // Present the scene
        view?.presentScene(GameScene(isTraining: true), transition: .crossFade(withDuration: 1.0))
    }
}
