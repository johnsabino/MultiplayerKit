//
//  MessageType.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 19/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//
import MultiplayerKit

struct StartGame: Message {
    var startPosition: CGPoint
    var playerColorR: CGFloat
    var playerColorG: CGFloat
    var playerColorB: CGFloat
}

struct Position: Message {
    var point: CGPoint, angle: CGFloat
}

struct Attack: Message { }
