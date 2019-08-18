//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public let mpKit = MultiplayerService.shared

open class MultiplayerService: NSObject {
    
    /** Multiplayer service Singleton */
    public static let shared = MultiplayerService()
    
    /** Referência para o GameCenter service */
    let gameCenterService = GameCenterService.shared
    
    /** Mínimo de jogadores na partida */
    private(set) var matchMinPlayers: Int = 2
    
    /** Máximo de jogadores na partida */
    private(set) var matchMaxPlayers: Int = 4
   
    /** Quantidade padráo de jogadores na partida */
    private(set) var defaultNumberOfPlayers: Int = 2
    
    /**
     Transmits data to all players connected to the match.
     - parameter data: the message to be send.
     - parameter mode: The mechanism used to send the data. The default is reliable
     */
    public func send<T: MessageProtocol>(_ data: T, with mode: GKMatch.SendDataMode = .reliable) {
        do {
            let dict: [String: Any] = ["\(T.self)": data.asDictionary]
            let dataEncoded = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            try gameCenterService.currentMatch?.sendData(toAllPlayers: dataEncoded, with: mode)
        } catch {
            print("Error while archive data: \(error)")
        }
    }
}
