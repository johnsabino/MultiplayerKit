//
//  MessageType.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 19/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//
import MultiplayerKit

struct StartGame: MessageProtocol {
    var startPosition: CGPoint
    var playerColorR: CGFloat
    var playerColorG: CGFloat
    var playerColorB: CGFloat
}

struct Position: MessageProtocol {
    var point: CGPoint, angle: CGFloat
}

struct Attack: MessageProtocol { }
