//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public typealias Message = [String: Any]
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
    public func send(_ data: [String: Any], with mode: GKMatch.SendDataMode = .reliable) {
        
        do {
            let dataArchived: Data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            try gameCenterService.currentMatch?.sendData(toAllPlayers: dataArchived, with: mode)
        } catch {
            print("Error while archive data: \(error)")
        }
    }
}
