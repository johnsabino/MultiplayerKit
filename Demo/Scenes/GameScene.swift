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
class GameScene: SKScene, Multiplayer {
    var inputController: InputController!
    var isTraining = false

    var playerNode: SpaceShip!
    var allPlayersNode: [GKPlayer: SpaceShip] = [:]

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        backgroundColor = .white
        setupCamera()
        setupJoystick()
        setupPlayers()

        physicsWorld.contactDelegate = self
        matchService.receiveDataDelegate = self
    }

    func setupPlayers() {
        playerNode = SpaceShip(gkPlayer: GKLocalPlayer.local,
                               color: .purple,
                               size: CGSize(width: 60, height: 60))
        playerNode.position = CGPoint.zero
        addChild(playerNode)

        //OBS: é necessário configuar os outros jogadores para coloca-los na cena
        players.forEach {
            let player = SpaceShip(gkPlayer: $0,
                                   color: .purple,
                                   size: CGSize(width: 60, height: 60))
            allPlayersNode[$0] = player
            addChild(player)
        }
//        if isTraining {
//            let player2 = SpaceShip(gkPlayer: GKPlayer(),
//                                    color: .purple,
//                                    size: CGSize(width: 60, height: 60))
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

        playerNode.physicsBody?.velocity = CGVector(dx: direction.x * 3, dy: direction.y * 3)
        playerNode.zRotation = angle

        let position = Position(x: playerNode.position.x,
                                y: playerNode.position.y,
                                angle: playerNode.zRotation)

        send(position)

    }
    func joystickDidEndTracking(direction: CGPoint) {
        playerNode.physicsBody?.velocity = CGVector.zero
    }

    func joystickDidTapButtonA() {
        playerNode.shoot(in: self)
    }

}

// MARK: ReceiveDataDelegate
extension GameScene: ReceiveDataDelegate {

    func didReceive(message: [String: Any], from player: GKPlayer) {
        guard let playerNode = allPlayersNode[player] else { return }

        message
        .caseIs(Position.self) { content in
            let point = CGPoint(x: content.x, y: content.y)
            playerNode.changePlayer(position: point, angle: content.angle)
        }
        .caseIs(StartGame.self) { _ in
            print("START")
        }
        .caseIs(Attack.self) { _ in
            print("ATTACK")
        }

    }

}

// MARK: ConnectionDelegate
extension GameScene: ConnectionDelegate {
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

            bulletNode.removeFromParent()

            if playerNode.name == "allyPlayer" && bulletNode.name == "enemyBullet" {
                playerNode.receiveDamage()

            }

        }

    }
}
