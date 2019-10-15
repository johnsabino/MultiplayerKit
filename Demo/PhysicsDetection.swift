//
//  PhysicsDetection.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 16/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit

struct ColliderType {
    static let none: UInt32 = UInt32.min
    static let all: UInt32 = UInt32.max
    static let player: UInt32 = 0x1 << 0
    static let enemy: UInt32 = 0x1 << 1
    static let bullet: UInt32 = 0x1 << 2
    static let enemyBullet: UInt32 = 0x1 << 3
}

class PhysicsDetection: NSObject, SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == ColliderType.player | ColliderType.bullet {
            print("COLIDIU")
        }

        if collision == ColliderType.player | ColliderType.player {
            print("collision between players")
        }

    }

}
