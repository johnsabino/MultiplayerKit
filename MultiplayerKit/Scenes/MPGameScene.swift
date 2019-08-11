//
//  MultiplayerGameScene.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

open class MPGameScene: SKScene, UpdateSceneDelegate, ConnectionDelegate {
    
    public var allPlayersNode: [Int: MPSpriteNode] = [:]
    
    public var multiplayer = MultiplayerService.shared
    public var otherPlayers: [GKPlayer] {
        guard let match = GameCenterService.shared.currentMatch else { return [] }
        return match.players
        
    }
    override public init(size: CGSize) {
        super.init(size: size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadPlayers(id: String, playerNode: MPSpriteNode) {
        allPlayersNode[id.intValue] = playerNode
        addChild(playerNode)
    }
    
    override open func didMove(to view: SKView) {
        super.didMove(to: view)
        multiplayer.updateSceneDelegate = self
    }
}

extension MPGameScene {
    @objc open func update(playerID: Int, in position: CGPoint, and angle: CGFloat) {
        if let player = allPlayersNode[playerID] {
            player.position = position
            player.zRotation = angle
        }
    }
    
    @objc open func didPlayerConnected() {
        
    }
    
}
