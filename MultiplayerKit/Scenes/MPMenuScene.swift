//
//  MultiplayerMenuScene.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

open class MPMenuScene: SKScene {

    var gameScene: SKScene!
    var matchmaker: Matchmaker
    // MARK: Init
    public init(gameScene: SKScene, matchmaker: Matchmaker) {
        self.matchmaker = matchmaker
        self.gameScene = gameScene
        super.init(size: gameScene.size)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup
    override open func didMove(to view: SKView) {
        super.didMove(to: view)
        NotificationCenter.default.addObserver(self, selector: #selector(authenticationChanged(_:)), name: .authenticationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentGame(_:)), name: .presentGame, object: nil)
    }

    @objc open func authenticationChanged(_ notification: Notification) {

    }

    public func presentMatchMaker() {
        matchmaker.present()
    }

    @objc open func presentGame(_ notification: Notification) {
        guard notification.object as? GKMatch != nil else {
            return
        }

        gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameScene.scaleMode = .resizeFill
        view?.ignoresSiblingOrder = true

        // Present the scene
        view?.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 1.0))

    }
}
