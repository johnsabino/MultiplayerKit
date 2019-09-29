//
//  GameViewController.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 08/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import MultiplayerKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let skView = view as? SKView {

            let matchmaker = Matchmaker(authenticationViewController: self)
            let menuScene = MenuScene(matchmaker: matchmaker)
            
            skView.presentScene(menuScene)
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            //skView.showsPhysics = true

        }

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
