//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public class MultiplayerService: NSObject {
    let messageTypes: [Message.Type]
    
    public weak var gameScene: MKGameScene? {
        didSet {
            MatchService.shared.setGameScene(gameScene)
        }
    }
    public init(_ messageTypes: Message.Type ...) {
        self.messageTypes = messageTypes
    }
    
    /**
     All players from the current match, except player of current device
     */
    public var players: [GKPlayer] {
        guard let match = MatchService.shared.currentMatch else { return [] }
        return match.players
    }

    /**
     Transmits data to all players connected to the match.
     - parameter data: the message to be send.
     - parameter mode: The mechanism used to send the data. The default is reliable
     */
    public func send<T: Message>(_ message: T, with mode: GKMatch.SendDataMode = .reliable) {
        do {
            guard let dataEncoded = message.encode() else { return }
            try MatchService.shared.currentMatch?.sendData(toAllPlayers: dataEncoded, with: mode)
        } catch {
            print("Error while archive data and send: \(error)")
        }
    }
}
