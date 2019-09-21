//
//  MultiplayerService.swift
//  MultiplayerKit
//
//  Created by João Paulo de Oliveira Sabino on 09/08/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

public protocol MessageProtocol: Codable { }

extension MessageProtocol {

    var dictionary: [String: Any] {
        let encode = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))
        let dictBase = encode as? [String: Any] ?? [:]
        let dictWithType = ["\(Self.self)": dictBase]
        return dictWithType
    }

    static func decode(_ data: Data) -> Self? {
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let type = "\(Self.self)"
        if json?.keys.first == type, let content = json?[type],
            let contentData = try? JSONSerialization.data(withJSONObject: content) {
            return try? JSONDecoder().decode(Self.self, from: contentData)
        } else {
            return nil
        }
    }

    func encode() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self.dictionary)
    }
}
