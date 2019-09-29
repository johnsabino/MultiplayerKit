//
//  SpaceShip.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 16/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import MultiplayerKit
import SpriteKit
import GameKit

class SpaceShip: MPSpriteNode {
    var hp: Int = 30

    override init(gkPlayer: GKPlayer, texture: SKTexture? = nil, color: UIColor, size: CGSize) {
        super.init(gkPlayer: gkPlayer, texture: texture, color: color, size: size)

        zPosition = 2
        name = isLocalPlayer ? "allyPlayer" : "enemyPlayer"
        let pb = SKPhysicsBody(rectangleOf: size)
        pb.affectedByGravity = false
        pb.categoryBitMask = ColliderType.player
        pb.contactTestBitMask = ColliderType.bullet
        pb.collisionBitMask = ColliderType.none
        physicsBody = pb
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func shoot(in scene: SKScene) {
        if hp <= 0 { return }
        let bullet = instantiateBullet(in: scene)
        addChild(bullet)
        let point = CGPoint(x: bullet.position.x * 10, y: bullet.position.y * 10)
        let move = SKAction.move(to: point, duration: 1)

        bullet.run(move) {
            bullet.removeFromParent()
        }
    }

    func instantiateBullet(in scene: SKScene) -> SKSpriteNode {
        let bullet = SKSpriteNode(color: .red, size: CGSize(width: 10, height: 10))
        bullet.position = convert(position, from: scene)
        bullet.position.y += 50
        bullet.name = isLocalPlayer ? "allyBullet" : "enemyBullet"
        let pb = SKPhysicsBody(rectangleOf: bullet.size)
        pb.affectedByGravity = false
        pb.categoryBitMask = ColliderType.bullet
        pb.contactTestBitMask = ColliderType.player
        pb.collisionBitMask = ColliderType.none
        bullet.physicsBody = pb

        return bullet
    }

    func receiveDamage() {
        hp -= 10
        if hp <= 0 {
            print("E MORREU...")
            removeFromParent()
        }
    }

}
