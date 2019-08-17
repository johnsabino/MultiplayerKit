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
    var isTraining = false
    //OBS: o player deve herdar de MPSpriteNode
    var player: SpaceShip!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        backgroundColor = .white
        setupCamera()
        setupJoystick()
        setupPlayers()
    
        physicsWorld.contactDelegate = self
    }
    
    func setupPlayers() {
        player = SpaceShip(gkPlayer: GKLocalPlayer.local, color: .purple, size: CGSize(width: 60, height: 60))
        player.position = CGPoint.zero
        addChild(player)
        
        //OBS: é necessário configuar os outros jogadores para coloca-los na cena
        otherPlayers.forEach {
            let player = SpaceShip(gkPlayer: $0, color: .purple, size: CGSize(width: 60, height: 60))
            loadPlayers(id: $0.playerID, playerNode: player)
        }
        
//        if isTraining {
//            let player2 = SpaceShip(gkPlayer: GKPlayer(), color: .purple, size: CGSize(width: 60, height: 60))
//            player2.position = CGPoint.zero
//            addChild(player2)
//        }
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

extension GameScene {
    override func didReceive(message: Message, from player: GKPlayer) {
        super.didReceive(message: message, from: player)
        guard let player = allPlayersNode[player.playerID.intValue] as? SpaceShip else { return }
        
        if let action = message["action"] as? String {
            switch action {
            case "attack":
                player.shoot(in: self)
            case "hitted":
                player.receiveDamage()
            default:
                break
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        let collision: UInt32 = categoryA | categoryB
        
        if collision == ColliderType.player | ColliderType.bullet {
            
            guard let playerNode = (categoryA == ColliderType.player ? nodeA : nodeB) as? SpaceShip else { return }
            guard let bulletNode = categoryA == ColliderType.bullet ? nodeA : nodeB else { return }
            
            bulletNode.removeFromParent()
            
            if playerNode.name == "allyPlayer" && bulletNode.name == "enemyBullet" {
                playerNode.receiveDamage()
                
            }

        }
    
    }
}
