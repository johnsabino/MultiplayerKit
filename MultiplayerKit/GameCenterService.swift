//
//  GameCenterService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public class GameCenterService: NSObject {
    static let shared = GameCenterService()
    
    var authenticationViewController: UIViewController?
    var currentMatch: GKMatch?
    var currentMatchmakerVC: GKMatchmakerViewController?
    weak var connectionDelegate: ConnectionDelegate?
    weak var receiveDataDelegate: ReceiveDataDelegate?
    
    static var isAuthenticated: Bool {
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
    
    func presentMatchMaker() {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        
        let request = GKMatchRequest()
        
        request.minPlayers = 2
        request.maxPlayers = 2
        request.defaultNumberOfPlayers = 2
        
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
        MultiplayerService.shared.sendData(data: Message.startGame)
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
        
        guard GKLocalPlayer.local.isAuthenticated else {return}
        
        GKMatchmaker.shared().match(for: invite) { (match, error) in
                        
            if let error = error {
                print("Error while accept invite: \(error)")
            } else if let match = match {
                self.startGame(match: match)
            }
        }
    }
}
