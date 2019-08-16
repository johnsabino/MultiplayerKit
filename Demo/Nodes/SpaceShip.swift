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
    
    override init(gkPlayer: GKPlayer, texture: SKTexture? = nil, color: UIColor, size: CGSize) {
        super.init(gkPlayer: gkPlayer, texture: texture, color: color, size: size)
        
        let pb = SKPhysicsBody(rectangleOf: size)
        pb.affectedByGravity = false
        pb.isDynamic = true
        pb.categoryBitMask = ColliderType.player
        pb.contactTestBitMask = ColliderType.bullet
        pb.collisionBitMask = ColliderType.none
        physicsBody = pb
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(in scene: SKScene) {
        let bullet = instantiateBullet()
        scene.addChild(bullet)
        let vector = CGVector(dx: sin(-zRotation) * 1000, dy: cos(-zRotation) * 1000)
        let move = SKAction.move(by: vector, duration: 2)
        
        bullet.run(move) {
            bullet.removeFromParent()
        }
        
    }
    
    func instantiateBullet() -> SKSpriteNode {
        let bullet = SKSpriteNode(color: .red, size: CGSize(width: 10, height: 10))
        bullet.position = position
        let pb = SKPhysicsBody(rectangleOf: bullet.size)
        pb.affectedByGravity = false
        pb.isDynamic = true
        pb.categoryBitMask = ColliderType.bullet
        pb.contactTestBitMask = ColliderType.player
        pb.collisionBitMask = ColliderType.none
        bullet.physicsBody = pb
        
        return bullet
    }
    
}
