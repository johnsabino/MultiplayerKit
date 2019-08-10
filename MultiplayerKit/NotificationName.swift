//
//  NotificationName.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

extension Notification.Name {
    //notifies the menu scene to present an online game
    static let presentGame = Notification.Name(rawValue: "presentGame")
    //notifies the app of any authentication state changed
    static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}
