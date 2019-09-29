//
//  MultiplayerGameScene.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import SpriteKit
import GameKit

public protocol MKGameScene: ReceiveDataDelegate, ConnectionDelegate {
    var multiplayerService: MultiplayerService {get set}
}
