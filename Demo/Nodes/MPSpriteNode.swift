//
//  MPSpriteNode.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import MultiplayerKit

open class MPSpriteNode: SKSpriteNode {
    public var gkPlayer: GKPlayer
    public var isLocalPlayer: Bool {
        return gkPlayer == GKLocalPlayer.local
    }

    private var lastPlayerPosition = CGPoint.zero

    public init(gkPlayer: GKPlayer, texture: SKTexture? = nil, color: UIColor, size: CGSize) {
        self.gkPlayer = gkPlayer
        super.init(texture: texture, color: color, size: size)

        let updateSprite = CADisplayLink(target: self, selector: #selector(update))
        updateSprite.preferredFramesPerSecond = 20
        updateSprite.add(to: .current, forMode: .default)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func send<T: MessageProtocol>(message: T) {
       // if isLocalPlayer { mpKit.send(message) }
    }

    public func sendPosition() {
        //send(message: Position(x: position.x, y: position.y, angle: zRotation))
    }

    public func changePlayer(position: CGPoint, angle: CGFloat = 0, smoothness: Double = 0.05) {
        run(SKAction.move(to: position, duration: smoothness))
        zRotation = angle
    }

    @objc func update() {
        if isLocalPlayer {
            let distance = hypot(position.x - lastPlayerPosition.x, position.y - lastPlayerPosition.y)
            let playerIsMoving = distance > 0
            if playerIsMoving {
                sendPosition()
            }
            lastPlayerPosition = position
        }
    }

}
