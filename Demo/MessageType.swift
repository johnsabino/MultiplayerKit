//
//  MessageType.swift
//  Demo
//
//  Created by João Paulo de Oliveira Sabino on 19/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//
import MultiplayerKit

struct StartGame: MessageProtocol { }
struct Attack: MessageProtocol { }

enum GameMessage: Message {
    case move(pos: CGPoint, angle: CGFloat)
    case message(msg: String)
    case array(a: [CGFloat])
}
