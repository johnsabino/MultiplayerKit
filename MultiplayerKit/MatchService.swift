//
//  Match.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 24/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public class MatchService: NSObject, GKMatchDelegate {
    static let shared = MatchService()
    weak var multiplayerService: MultiplayerService?
    public var currentMatch: GKMatch?
    public weak var connectionDelegate: ConnectionDelegate?
    public weak var receiveDataDelegate: ReceiveDataDelegate?

    override public init() {
        super.init()
        print("INIT MATCH SERVICE")
    }
    public func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        //print("JSON: ", try? JSONSerialization.jsonObject(with: data))
        multiplayerService?.messageTypes.forEach {
            if let message = $0.decode(data) {
                receiveDataDelegate?.didReceive(message: message, from: player)
            }
        }
    }

    public func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if self.currentMatch != match { return }

        switch state {
        case .connected:
            print("Player Conected!")
            connectionDelegate?.didPlayerConnected()

        case .disconnected:
            print("Player Disconected!")
        default:
            print(state)
        }
    }

    func didGameStarted(_ match: GKMatch) {
        print("START GAME")
        self.currentMatch = match
        match.delegate = self
        NotificationCenter.default.post(name: .presentGame, object: match)
    }
}
