//
//  GameScene.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 08/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var inputController: InputController!
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.gray
        setupJoystick()
    }
    
    func setupJoystick() {
        let inputSize = CGSize(width: self.size.width, height: self.size.height)
        inputController = InputController(size: inputSize)
        inputController.zPosition = 10
        inputController.position = self.position
        inputController.joystickDelegate = self
        
        if let cam = self.camera {
            cam.addChild(inputController)
        }
        
    }
}

extension GameScene: JoystickDelegate {
    func joystickDidStartTracking() {
        
    }
    
    func joystickDidMoved(direction: CGPoint) {
        
    }
    
    func joystickUpdateTracking(direction: CGPoint) {
        
    }
    
    func joystickDidEndTracking(direction: CGPoint) {
        
    }
    
    func joystickDidTapButtonA() {
        
    }
    
    func joystickDidTapButtonB() {
        
    }
    
    func joystickDidTapDown() {
        
    }
    
}
