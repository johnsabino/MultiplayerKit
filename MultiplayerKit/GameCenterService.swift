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
    weak var receiveDataDelegate: ReceiveDataDelegate?
    
    var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    override init() {
        super.init()
        
        GKLocalPlayer.local.authenticateHandler = { authenticationVC, error in
            
            NotificationCenter.default.post(name: .authenticationChanged, object: GKLocalPlayer.local.isAuthenticated)
            
            if GKLocalPlayer.local.isAuthenticated {
                GKLocalPlayer.local.register(self)
                print("Authenticated to Game Center!")
                
            } else if let vc = authenticationVC {
                self.authenticationViewController?.present(vc, animated: true)
            } else {
                print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
            }
            
        }
        
    }
    
    public func presentMatchMaker() {
        if !isAuthenticated {return}

        let request = GKMatchRequest()
        
        request.minPlayers = MultiplayerService.shared.matchMinPlayers
        request.maxPlayers = MultiplayerService.shared.matchMaxPlayers
        request.defaultNumberOfPlayers = MultiplayerService.shared.defaultNumberOfPlayers
        
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
        MultiplayerService.shared.send(.startGame)
        NotificationCenter.default.post(name: .presentGame, object: match)
    }
    
}

extension GameCenterService: GKMatchDelegate {
    public func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let dataUnarchived = Message.unarchive(data) {
            receiveDataDelegate?.didReceive(message: dataUnarchived, from: player)
            
            if case .startGame = dataUnarchived {
                print("START GAME 2")
            }
        }
    }
    
    public func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        if self.currentMatch != match { return }
        
        switch state {
        case GKPlayerConnectionState.connected:
            print("Player Conected!")
            connectionDelegate?.didPlayerConnected()
            
        case GKPlayerConnectionState.disconnected:
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
