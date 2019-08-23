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
            //OBS: é necessário configuar as cenas de menu e de jogo
            let gameScene = GameScene(size: view.frame.size)
            let menuScene = MenuScene(gameScene: gameScene)
            //let scene = GameScene(size: view.frame.size)
            menuScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            menuScene.scaleMode = .resizeFill
            skView.presentScene(menuScene)

            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            //skView.showsPhysics = true

            //OBS: é necessário setar a view controller de autenticação
            GameCenterService.shared.authenticationViewController = self
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
