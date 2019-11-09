//
//  SKSpriteNode+Extension.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 09/11/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    convenience init(texture: SKTexture, scale: CGFloat) {
        self.init(texture: texture)
        texture.filteringMode = .nearest
        size = CGSize(width: texture.size().width * scale, height: texture.size().height * scale)
    }
}
