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
    
    convenience init(gkPlayer: GKPlayer, texture: SKTexture) {
        texture.filteringMode = .nearest
        let size = CGSize(width: texture.size().width * 2, height: texture.size().height * 2)
        self.init(gkPlayer: gkPlayer, texture: texture, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func movePlayer(toDirection: CGPoint, andAngle: CGFloat) {
        physicsBody?.velocity = CGVector(dx: toDirection.x * 3, dy: toDirection.y * 3)
        zRotation = andAngle
    }

    func shoot(in scene: SKScene) {
        if hp <= 0 { return }
        let bullet = instantiateBullet(in: scene)
        scene.addChild(bullet)
        let distance: CGFloat = 300
        let point = CGPoint(x: distance * cos(zRotation + (CGFloat.pi/2)) + bullet.position.x,
                            y: distance * sin(zRotation + (CGFloat.pi/2)) + bullet.position.y)
        let move = SKAction.move(to: point, duration: 1)

        bullet.run(move) {
            bullet.removeFromParent()
        }
    }

    func instantiateBullet(in scene: SKScene) -> SKSpriteNode {
        let bullet = SKSpriteNode(texture: SKTexture(imageNamed: "bullet"), scale: 2)
        bullet.zPosition = 1
        bullet.zRotation = zRotation
        bullet.position = position
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
            print("DIED...")
            removeFromParent()
        }
    }

}
