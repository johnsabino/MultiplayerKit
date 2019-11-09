//
//  GameScene.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 08/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import MultiplayerKit

class GameScene: SKScene, MKGameScene {

    var multiplayerService = MultiplayerService(Position.self, Attack.self, StartGame.self)
    var inputController: InputController!
    var isTraining = false
    var background = SKSpriteNode(texture: SKTexture(imageNamed: "desert-backgorund"))
    var playerNode: SpaceShip!
    var allPlayersNode: [GKPlayer: SpaceShip] = [:]

    init(isTraining: Bool = false) {
        self.isTraining = isTraining
        super.init(size: .zero)
        multiplayerService.gameScene = self
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        view.ignoresSiblingOrder = true
        backgroundColor = .white
        setupBackground()
        setupCamera()
        setupJoystick()
        setupPlayers()
        physicsWorld.contactDelegate = self
    }

    func setupBackground() {
        background.position = .zero
        background.texture?.filteringMode = .nearest
        if let backGTexture = background.texture {
            background.size = CGSize(width: backGTexture.size().width * 3, height: backGTexture.size().height * 3)
        }
        addChild(background)
    }
    func setupPlayers() {
        playerNode = SpaceShip(gkPlayer: GKLocalPlayer.local, texture: SKTexture(imageNamed: "ship"))
        playerNode.position = .zero
        addChild(playerNode)

        multiplayerService.players.forEach {
            let player = SpaceShip(gkPlayer: GKLocalPlayer.local, texture: SKTexture(imageNamed: "ship"))
            allPlayersNode[$0] = player
            addChild(player)
        }

        if isTraining {
            let player2 = SpaceShip(gkPlayer: GKLocalPlayer.local, texture: SKTexture(imageNamed: "ship"))
            player2.name = "enemyPlayer"
            player2.position = .zero
            addChild(player2)
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
        playerNode.movePlayer(toDirection: direction, andAngle: angle)
        let position = Position(point: playerNode.position,
                                angle: playerNode.zRotation)

        multiplayerService.send(position)

    }
    func joystickDidEndTracking(direction: CGPoint) {
        playerNode.physicsBody?.velocity = CGVector.zero
    }

    func joystickDidTapButtonA() {
        playerNode.shoot(in: self)
    }

}

// MARK: ReceiveData
extension GameScene {

    func didReceive(message: Message, from player: GKPlayer) {
        guard let playerNode = allPlayersNode[player] else { return }

        switch message {
        case let position as Position:
            playerNode.changePlayer(position: position.point, angle: position.angle)
        case let startGame as StartGame:
            print("START GAME!!! \(startGame)")
        case let attack as Attack:
            print("ATTACK!!! \(attack)")
        default:
            break
        }
    }

    func didPlayerConnected() {
    }
}

// MARK: ContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask

        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        let collision: UInt32 = categoryA | categoryB

        if collision == ColliderType.player | ColliderType.bullet {

            guard let playerNode = (categoryA == ColliderType.player ? nodeA : nodeB) as? SpaceShip
                else { return }
            guard let bulletNode = categoryA == ColliderType.bullet ? nodeA : nodeB else { return }
            if (playerNode.name == "allyPlayer" && bulletNode.name == "enemyBullet") ||
                (playerNode.name == "enemyPlayer" && bulletNode.name == "allyBullet") {
                print("HIT")
                bulletNode.removeFromParent()
                playerNode.receiveDamage()

            }

        }

    }
}

class Other: SKScene, MKGameScene {
    var multiplayerService: MultiplayerService = MultiplayerService(Position.self)
    
    func didReceive(message: Message, from player: GKPlayer) {

    }
    
    func didPlayerConnected() {
        
    }

}
