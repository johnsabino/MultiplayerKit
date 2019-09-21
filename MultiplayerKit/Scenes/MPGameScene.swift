//
//  MultiplayerGameScene.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

public protocol GameSceneProtocol: ReceiveDataDelegate, ConnectionDelegate {
    var multiplayerService: MultiplayerService? {get set}
    init()
    init(multiplayerService: MultiplayerService?)
}
public extension GameSceneProtocol {

    init(multiplayerService: MultiplayerService?) {
        self.init()
        multiplayerService?.matchService.receiveDataDelegate = self
        multiplayerService?.matchService.connectionDelegate = self
        self.multiplayerService = multiplayerService
    }
}
open class MPGameScene: SKScene {

    public var allPlayersNode: [Int: MPSpriteNode] = [:]

    //public var multiplayer = MultiplayerService.shared
//    public var otherPlayers: [GKPlayer] {
//        guard let match = GameCenterService<Test>().currentMatch else { return [] }
//        return match.players
//
//    }
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
        //GameCenterService.shared.receiveDataDelegate = self
    }

//    open func didReceive(message: Data, from player: GKPlayer, messageType: MessageProtocol.Type) {
//        message
//            .caseIs(Position.self) {
//                if let playerNode = allPlayersNode[player.playerID.intValue] {
//                    playerNode.changePlayer(position: CGPoint(x: $0.positionX, y: $0.positionY), angle: $0.angle)
//                }
//        }
//    }
}

// MARK: - UpdateSceneDelegate

    //open func didReceive(message: Message, from player: GKPlayer) {
        //Did receive position
        //print("MESSAGE: \(message)")
//        if let content = message.content as? Position, let player = allPlayersNode[player.playerID.intValue] {
//            
//            player.changePlayer(position: content.position, angle: content.angle)
//        }
    //}

// MARK: - ConnectionDelegate
extension MPGameScene: ConnectionDelegate {
    @objc open func didPlayerConnected() {

    }

}
