//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public protocol Multiplayer {

}

public extension Multiplayer {
    var gameCenter: GameCenterService {
        return GameCenterService.shared
    }
    var players: [GKPlayer] {
        guard let match = GameCenterService.shared.currentMatch else { return [] }
        return match.players
    }

    /**
     Transmits data to all players connected to the match.
     - parameter data: the message to be send.
     - parameter mode: The mechanism used to send the data. The default is reliable
     */
    func send<T: Msg>(_ data: T, with mode: GKMatch.SendDataMode = .reliable) {
        do {
            //let dict: [String: Any] = ["\(T.self)": data.asDictionary]
            //let dataEncoded = try JSONSerialization.data(withJSONObject: dict)
            let dataEncoded = encode(value: data) as Data
            try GameCenterService.shared.currentMatch?.sendData(toAllPlayers: dataEncoded, with: mode)
        } catch {
            print("Error while archive data and send: \(error)")
        }
    }
}
