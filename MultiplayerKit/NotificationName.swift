//
//  NotificationName.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

public extension Notification.Name {
    ///Notifies the menu scene to present an online game
    static let presentGame = Notification.Name(rawValue: "presentGame")
    ///Notifies the app of any authentication state changed
    static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}
