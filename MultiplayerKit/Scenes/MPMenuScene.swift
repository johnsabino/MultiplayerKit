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
    
    var multiplayerGameScene: MPGameScene!
    
    // MARK: Inits
    override public init(size: CGSize) {
        super.init(size: size)
    }
    convenience public init(multiplayerGameScene: MPGameScene) {
        self.init(size: multiplayerGameScene.size)
        self.multiplayerGameScene = multiplayerGameScene
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
    
    @objc open func presentGame(_ notification: Notification) {
        guard let match = notification.object as? GKMatch else {
            return
        }
        
        GameCenterService.shared.connectionDelegate = multiplayerGameScene
        multiplayerGameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        multiplayerGameScene.scaleMode = .resizeFill
        view?.ignoresSiblingOrder = true
        
        // Present the scene
        view?.presentScene(multiplayerGameScene, transition: SKTransition.crossFade(withDuration: 1.0))
        
        GameCenterService.shared.currentMatch = match
    }
}
