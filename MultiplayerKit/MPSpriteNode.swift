//
//  MPSpriteNode.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

open class MPSpriteNode: SKSpriteNode {
    var playerID: String = ""
    var playerAlias: String = ""
    private var lastPlayerPosition = CGPoint.zero
    
    public override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        let updateSprite = CADisplayLink(target: self, selector: #selector(update))
        updateSprite.preferredFramesPerSecond = 60
        updateSprite.add(to: .current, forMode: .default)
    }
    
    public convenience init(playerID: String = "", playerAlias: String = "", texture: SKTexture? = nil, color: UIColor, size: CGSize) {
        self.init(texture: texture, color: color, size: size)
        self.playerID = playerID
        self.playerAlias = playerAlias
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func sendPosition() {
        MultiplayerService.shared.send(.position(position, angle: zRotation))
    }
    
    @objc func update() {
        if playerID == GKLocalPlayer.local.playerID {
            let distance = hypot(position.x - lastPlayerPosition.x, position.y - lastPlayerPosition.y)
            if distance > 0 {
                sendPosition()
            }
            lastPlayerPosition = position
        }
    }
    
}
