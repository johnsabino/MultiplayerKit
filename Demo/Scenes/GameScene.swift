//
//  GameScene.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 08/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import MultiplayerKit
import GameKit

//OBS: a cena do menu deve herdar de MPMenuScene
class GameScene: MPGameScene {
    var inputController: InputController!
    
    //OBS: o player deve herdar de MPSpriteNode
    var player: SpaceShip!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        backgroundColor = SKColor.black
        setupCamera()
        setupJoystick()
        setupPlayers()
        
    }
    
    func setupPlayers() {
        player = SpaceShip(gkPlayer: GKLocalPlayer.local, color: UIColor.purple, size: CGSize(width: 60, height: 60))
        player.position = CGPoint.zero
        addChild(player)
        
        //OBS: é necessário configuar os outros jogadores para coloca-los na cena
        otherPlayers.forEach {
            let player = SpaceShip(gkPlayer: $0, color: UIColor.purple, size: CGSize(width: 60, height: 60))
            loadPlayers(id: $0.playerID, playerNode: player)
        }
    }
    
    func setupCamera() {
        let camera = SKCameraNode()
        self.camera = camera
        self.addChild(camera)
    }
    
    func setupJoystick() {
        let inputSize = CGSize(width: self.size.width, height: self.size.height)
        inputController = InputController(size: inputSize)
        inputController.zPosition = 10
        inputController.position = self.position
        inputController.joystickDelegate = self
        
        if let cam = self.camera {
            cam.addChild(inputController)
        }
        
    }
}

extension GameScene: JoystickDelegate {
    func joystickUpdateTracking(direction: CGPoint, angle: CGFloat) {
        //movimentação local do jogador
        
        player.physicsBody?.velocity = CGVector(dx: direction.x * 3, dy: direction.y * 3)
        player.zRotation = angle
        
    }
    func joystickDidEndTracking(direction: CGPoint) {
        player.physicsBody?.velocity = CGVector.zero
    }
    
    func joystickDidTapButtonA() {
        player.shoot(in: self)
    }
}
