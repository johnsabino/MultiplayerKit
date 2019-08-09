//
//  Message.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

enum MessageType {
    
}

enum Message {
    case move(dx: Float, dy: Float)
    case pressA
    case pressB
    
    //    //Struct to data
    func archive() -> Data {
        let aaa = self
        print(aaa)
        var data = self
        return Data(bytes: &data, count: MemoryLayout.stride(ofValue: data))
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
