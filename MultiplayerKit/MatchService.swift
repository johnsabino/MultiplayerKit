//
//  Match.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 24/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public class MatchService: NSObject, GKMatchDelegate {
    public static let shared = MatchService()

    public var currentMatch: GKMatch?
    public weak var connectionDelegate: ConnectionDelegate?
    public weak var receiveDataDelegate: ReceiveDataDelegate?

    override public init() {
        super.init()
        print("MATCH SERVICE INIT")
    }
    public func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let message = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            receiveDataDelegate?.didReceive(message: message, from: player)
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
