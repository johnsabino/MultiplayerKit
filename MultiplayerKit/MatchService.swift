//
//  Match.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 24/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

class MatchService: NSObject, GKMatchDelegate {
    static let shared = MatchService()
    weak var multiplayerService: MultiplayerService?
    var currentMatch: GKMatch?
    
    weak var connectionDelegate: ConnectionDelegate?
    weak var receiveDataDelegate: ReceiveDataDelegate?
    weak var gamePresentationDelegate: GamePresentationDelegate?

    func setGameScene(_ gameScene: MKGameScene?) {
        connectionDelegate = gameScene
        receiveDataDelegate = gameScene
        multiplayerService = gameScene?.multiplayerService
    }
    
    public func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        multiplayerService?.messageTypes.forEach {
            if let message = $0.decode(data) {
                receiveDataDelegate?.didReceive(message: message, from: player)
            }
        }
    }

    public func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if self.currentMatch == match && state == .connected {
            connectionDelegate?.didPlayerConnected()
        }
    }

    func didGameStarted(_ match: GKMatch) {
        self.currentMatch = match
        match.delegate = self
        gamePresentationDelegate?.willStartGame()
    }
    
    func setMatchDelegate(_ multiplayerService: MultiplayerService) { }
}
