//
//  ReceiveDataDelegate.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 10/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//
import GameKit

public protocol ReceiveDataDelegate: class {
    func didReceive(message: MessageProtocol, from player: GKPlayer)
}
