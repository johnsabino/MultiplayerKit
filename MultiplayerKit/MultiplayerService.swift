//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public protocol Multiplayer { }

public extension Multiplayer {
    var matchService: MatchService {
        return MatchService.shared
    }

    var players: [GKPlayer] {
        guard let match = Matchmaker.shared.currentMatch else { return [] }
        return match.players
    }

    /**
     Transmits data to all players connected to the match.
     - parameter data: the message to be send.
     - parameter mode: The mechanism used to send the data. The default is reliable
     */
    func send<T: MessageProtocol>(_ message: T, with mode: GKMatch.SendDataMode = .reliable) {
        do {
            let dictionary = ["\(T.self)": message.asDictionary]
            let dataEncoded = try JSONSerialization.data(withJSONObject: dictionary)
            try matchService.currentMatch?.sendData(toAllPlayers: dataEncoded, with: mode)
        } catch {
            print("Error while archive data and send: \(error)")
        }
    }
}
