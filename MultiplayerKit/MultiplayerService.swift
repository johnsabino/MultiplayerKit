//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

class MultiplayerService: NSObject {
    //singleton of Multiplayer service
    static let shared = MultiplayerService()
    
    //reference to GameCenter service singleton
    let gameCenterService = GameCenterService.shared
    
    //Configuração do número de jogadores na partida
    private(set) var matchMinPlayers: Int = 2
    private(set) var matchMaxPlayers: Int = 4
    private(set) var defaultNumberOfPlayers: Int = 2
    
    //Referência para o jogador e outros jogadores na partida
    private(set) var player = GKLocalPlayer.local
    var otherPlayers: [GKPlayer] {
        guard let match = gameCenterService.currentMatch else { return [] }
        return match.players
        
    }
    weak var updateSceneDelegate: UpdateSceneDelegate?
    
    override init() {
        super.init()
        gameCenterService.receiveDataDelegate = self
    }
    
    func sendData(data: Message, sendDataMode: GKMatch.SendDataMode = .reliable) {
        
        do {
            let dataArchived = data.archive()
            try GameCenterService.shared.currentMatch?.sendData(toAllPlayers: dataArchived, with: sendDataMode)
        } catch {
            print("Error while archive data: \(error)")
        }
    }
}

extension MultiplayerService: ReceiveDataDelegate {
    func didReceive(message: Message, from player: GKPlayer) {
        switch message {
        case .startGame:
            print("START GAME")
        case .send(let position):
            print("position: \(position)")
        case .sendAttack(let hittedPlayers):
            print("hittedPlayer: \(hittedPlayers.alias)")
        }
    }
    
}
