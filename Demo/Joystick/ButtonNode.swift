//
//  ButtonNode.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 01/03/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    var actionBlock : (() -> Void)?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    
    }
    
    convenience init(text: String, color: UIColor = .gray, size: CGSize = CGSize(width: 150, height: 50)) {
        self.init(color: color, size: size)
    
        isUserInteractionEnabled = true
        addChild(createButtonLabel(withText: text))
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButtonLabel(withText text: String) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontName = "Helvetica Bold"
        label.fontColor = .white
        label.fontSize = 14
        label.position.y = -6
        label.zPosition = 2
        return label
    }
    
    var isEnabled: Bool = false {
        didSet {
            alpha = isEnabled ? 1 : 0.4
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard isEnabled else {
            return
        }
        
        self.run(SKAction.fadeAlpha(to: 0.2, duration: 0.1))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let block = actionBlock, isEnabled {
            block()
        }
        guard isEnabled else {
            return
        }
        
        self.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
    }
}
