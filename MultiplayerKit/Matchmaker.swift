//
//  Matckmaker.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 24/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public class Matchmaker: NSObject, GKMatchmakerViewControllerDelegate {

    public enum AuthenticationState {
        case authenticated
        case nonAuthenticated
    }

    public var authenticationViewController: UIViewController?
    public var currentMatch: GKMatch?
    var currentMatchmakerVC: GKMatchmakerViewController?
    weak var authenticationDelegate: AuthenticationDelegate?
    var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }

    public init(authenticationViewController: UIViewController) {
        self.authenticationViewController = authenticationViewController
        super.init()
        GKLocalPlayer.local.authenticateHandler = { authenticationVC, error in
            NotificationCenter.default.post(name: .authenticationChanged, object: self.isAuthenticated)

            if self.isAuthenticated {
                self.authenticationDelegate?.didAuthenticationChanged(to: .authenticated)
                GKLocalPlayer.local.register(self)
                print("Authenticated to Game Center!")

            } else if let vc = authenticationVC {
                self.authenticationViewController?.present(vc, animated: true)
            } else {
                self.authenticationDelegate?.didAuthenticationChanged(to: .nonAuthenticated)
                print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
            }

        }
    }

    public func present(minPlayers: Int = 2, maxPlayers: Int = 4, defaultNumberOfPlayers: Int = 4) {
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

    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {

        self.currentMatch = match
        MatchService.shared.didGameStarted(match)

        if let vc = currentMatchmakerVC {
            currentMatchmakerVC = nil
            vc.dismiss(animated: true)
        }

    }

    public func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }

    public func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
    }
}

extension Matchmaker: GKLocalPlayerListener {
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
