//
//  MultiplayerGameScene.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

open class MPGameScene: SKScene {
    
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
        GameCenterService.shared.receiveDataDelegate = self
    }
}

// MARK: - UpdateSceneDelegate
extension MPGameScene: ReceiveDataDelegate {
    @objc open func didReceive(message: Data, from player: GKPlayer) {
        message
            .caseIs(Position.self) {
                if let playerNode = allPlayersNode[player.playerID.intValue] {
                    playerNode.changePlayer(position: CGPoint(x: $0.positionX, y: $0.positionY), angle: $0.angle)
                }
            }
    }
    
    //open func didReceive(message: Message, from player: GKPlayer) {
        //Did receive position
        //print("MESSAGE: \(message)")
//        if let content = message.content as? Position, let player = allPlayersNode[player.playerID.intValue] {
//            
//            player.changePlayer(position: content.position, angle: content.angle)
//        }
    //}

}
// MARK: - ConnectionDelegate
extension MPGameScene: ConnectionDelegate {
    @objc open func didPlayerConnected() {
        
    }
    
}
