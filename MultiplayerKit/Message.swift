//
//  Message.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import GameKit

public enum MessageType {
    case startGame
    case send
    case sendAttack(hittedPlayers: GKPlayer)
}

public enum Message {
    case startGame
    case position(CGPoint, angle: CGFloat)
    case attack(hittedPlayers: GKPlayer)
    
    //Struct to data
    static func archive(_ data: Message) -> Data {
        var d = data
        return Data(bytes: &d, count: MemoryLayout.stride(ofValue: d))
    }
    
    //Data to struct
    static func unarchive(_ data: Data) -> Message? {
        guard data.count == MemoryLayout<Message>.stride else {
            fatalError("Error!")
        }
        
        var message: Message?
        
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> Void in
            message = bytes.load(as: Message.self)
        }
        
        return message
    }
}
