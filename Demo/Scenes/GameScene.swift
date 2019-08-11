//
//  GameScene.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 08/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import MultiplayerKit

class Player: MPSpriteNode {
    
}

class GameScene: MPGameScene {
    var inputController: InputController!
    
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        backgroundColor = SKColor.black
        setupCamera()
        setupJoystick()
        
        player = Player(color: UIColor.purple, size: CGSize(width: 60, height: 60))
        player.position = CGPoint.zero
        addChild(player)
        
        otherPlayers.forEach { (gkPlayer) in
            let player = Player(color: UIColor.purple, size: CGSize(width: 60, height: 60))
            loadPlayers(id: gkPlayer.playerID, playerNode: player)
        }
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
    func setupCamera() {
        let camera = SKCameraNode()
        self.camera = camera
        self.addChild(camera)
    }
}

extension GameScene: JoystickDelegate {
    func joystickDidStartTracking() {
        
    }
    
    func joystickDidMoved(direction: CGPoint) {
        
    }
    
    func joystickUpdateTracking(direction: CGPoint, angle: CGFloat) {
        player.position.x += direction.x * 0.1
        player.position.y += direction.y * 0.1
        player.zRotation = -(angle)
        print("direction: \(direction), angle: \(angle)")
        
        multiplayer.send(.position(player.position, angle: angle))
    }
    
    func joystickDidEndTracking(direction: CGPoint) {
        
    }
    
    func joystickDidTapButtonA() {
        
    }
    
    func joystickDidTapButtonB() {
        
    }
    
    func joystickDidTapDown() {
        
    }
    
}

// MARK: update scene
extension GameScene {
    override func update(playerID: Int, in position: CGPoint, and angle: CGFloat) {
        super.update(playerID: playerID, in: position, and: angle)
    }
}

// MARK: connections
extension GameScene {
    override func didPlayerConnected() {
        
    }
}
