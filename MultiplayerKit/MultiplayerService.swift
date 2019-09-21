//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public protocol MultiplayerService: class {
    /**
     All messages types used to send and receive data.
     Example:
     [StartGame.self, Position.self, Attack.self]
     */
    var messageTypes: [MessageProtocol.Type] {get set}
    //init()
    //init<T: ReceiveDataDelegate>(multiplayerGameScene: T)
}

public extension MultiplayerService {
//    init<T: ReceiveDataDelegate>(multiplayerGameScene: T) {
//        self.init()
//        matchService.receiveDataDelegate = multiplayerGameScene
//    }
    var matchService: MatchService {
        return MatchService.shared
    }
    /**
     All players from the current match, except current device player
     */
    var players: [GKPlayer] {
        guard let match = matchService.currentMatch else { return [] }
        print("get p match: \(match) -- players: \(match.players.count)")
        return match.players
    }

    /**
     Transmits data to all players connected to the match.
     - parameter data: the message to be send.
     - parameter mode: The mechanism used to send the data. The default is reliable
     */
    func send<T: MessageProtocol>(_ message: T, with mode: GKMatch.SendDataMode = .reliable) {
        do {
            guard let dataEncoded = message.encode() else { return }
            try matchService.currentMatch?.sendData(toAllPlayers: dataEncoded, with: mode)
        } catch {
            print("Error while archive data and send: \(error)")
        }
    }
}
