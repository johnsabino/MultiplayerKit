//
//  GameCenterService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public class GameCenterService: NSObject {
    public static let shared = GameCenterService()

    public var authenticationViewController: UIViewController?
    public var currentMatch: GKMatch?
    var currentMatchmakerVC: GKMatchmakerViewController?
    public weak var connectionDelegate: ConnectionDelegate?
    public weak var receiveDataDelegate: ReceiveDataDelegate?

    var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }

    override init() {
        super.init()

        GKLocalPlayer.local.authenticateHandler = { authenticationVC, error in

            NotificationCenter.default.post(name: .authenticationChanged, object: self.isAuthenticated)

            if self.isAuthenticated {
                GKLocalPlayer.local.register(self)
                print("Authenticated to Game Center!")

            } else if let vc = authenticationVC {
                self.authenticationViewController?.present(vc, animated: true)
            } else {
                print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
            }

        }
    }

    public func presentMatchMaker(minPlayers: Int = 2, maxPlayers: Int = 4, defaultNumberOfPlayers: Int = 4) {
        if !isAuthenticated {return}

        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        request.defaultNumberOfPlayers = defaultNumberOfPlayers
        request.inviteMessage = "Would you like to play?"

        if let vc = GKMatchmakerViewController(matchRequest: request) {
            vc.matchmakerDelegate = self
            currentMatchmakerVC = vc
            authenticationViewController?.present(vc, animated: true)
        }
    }
}

extension GameCenterService: GKMatchmakerViewControllerDelegate {

    public func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }

    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker did fail with error: \(error.localizedDescription).")
    }

    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {

        startGame(match: match)

        if let vc = currentMatchmakerVC {
            currentMatchmakerVC = nil
            vc.dismiss(animated: true)
        }

    }

    public func startGame(match: GKMatch) {
        self.currentMatch = match
        match.delegate = self
        NotificationCenter.default.post(name: .presentGame, object: match)
    }

}

extension GameCenterService: GKMatchDelegate {
    public func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        //if let set = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            receiveDataDelegate?.didReceive(message: data, from: player)
        //}
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
}

extension GameCenterService: GKLocalPlayerListener {
    public func player(_ player: GKPlayer, didAccept invite: GKInvite) {

//        guard GKLocalPlayer.local.isAuthenticated else {return}
//        
//        GKMatchmaker.shared().match(for: invite) { (match, error) in
//                        
//            if let error = error {
//                print("Error while accept invite: \(error)")
//            } else if let match = match {
//                self.startGame(match: match)
//            }
//        }
    }
}
