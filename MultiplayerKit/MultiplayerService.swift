//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public typealias Message = [String: Any]

open class MultiplayerService: NSObject {
    //singleton of Multiplayer service
    public static let shared = MultiplayerService()
    
    //reference to GameCenter service singleton
    let gameCenterService = GameCenterService.shared
    
    //Configuração do número de jogadores na partida
    private(set) var matchMinPlayers: Int = 2
    private(set) var matchMaxPlayers: Int = 4
    private(set) var defaultNumberOfPlayers: Int = 2
    
    //Referência para o jogador e outros jogadores na partida
    private(set) var player = GKLocalPlayer.local
    
    override public init() {
        super.init()
//        gameCenterService.receiveDataDelegate = self
    }
    
    public func send(_ data: [String: Any], sendDataMode: GKMatch.SendDataMode = .reliable) {
        
        do {
            let dataArchived: Data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            try gameCenterService.currentMatch?.sendData(toAllPlayers: dataArchived, with: sendDataMode)
        } catch {
            print("Error while archive data: \(error)")
        }
    }
}
