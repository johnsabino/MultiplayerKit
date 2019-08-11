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
    
    public override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(playerID: String, playerAlias: String) {
        self.init()
        self.playerID = playerID
        self.playerAlias = playerAlias
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
