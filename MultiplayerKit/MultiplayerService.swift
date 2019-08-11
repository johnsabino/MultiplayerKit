//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public class MultiplayerService: NSObject {
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
    
    public weak var updateSceneDelegate: UpdateSceneDelegate?
    
    override public init() {
        super.init()
        gameCenterService.receiveDataDelegate = self
    }
    
    public func send(_ data: Message, sendDataMode: GKMatch.SendDataMode = .reliable) {
        
        do {
            let dataArchived = Message.archive(data)
            try gameCenterService.currentMatch?.sendData(toAllPlayers: dataArchived, with: sendDataMode)
        } catch {
            print("Error while archive data: \(error)")
        }
    }
}

extension MultiplayerService: ReceiveDataDelegate {
    public func didReceive(message: Message, from player: GKPlayer) {
        
        switch message {
        case .startGame:
            print("START GAME")
        case .position(let position, let angle):
            updateSceneDelegate?.update(playerID: player.playerID.intValue, in: position, and: angle)
        case .attack(let hittedPlayers):
            print("hittedPlayer: \(hittedPlayers.alias)")
        }
    }
    
}
