//
//  PhysicsDetection.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 16/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit

struct ColliderType {
    static let none: UInt32 = UInt32.min // collide with all
    static let all: UInt32 = UInt32.max // collide with all
    static let player: UInt32 = 0x1 << 0 // 000000001 = 1
    static let bullet: UInt32 = 0x1 << 1 // 000000010 = 2 // 000000100 = 4
}

class PhysicsDetection: NSObject, SKPhysicsContactDelegate {
    //var player: CharacterNode?
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
        if collision == ColliderType.player | ColliderType.bullet {
            
        }
        
        if collision == ColliderType.player | ColliderType.player {
            print("collision between players")
        }
        
    }
    
}
