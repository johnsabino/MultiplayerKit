//
//  MenuSceneProtocol.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 29/09/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

public protocol MKMenuScene: SKScene, AuthenticationDelegate, GamePresentationDelegate {
    var matchmaker: Matchmaker? {get set}
    init()
    init(matchmaker: Matchmaker)
}

public extension MKMenuScene {
    init(matchmaker: Matchmaker) {
        self.init()
        self.matchmaker = matchmaker
        matchmaker.authenticationDelegate = self
        MatchService.shared.gamePresentationDelegate = self
    }
    
    func presentMatchMaker() {
        matchmaker?.present()
    }
}
