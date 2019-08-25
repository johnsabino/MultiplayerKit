public extension Dictionary where Key == String {
    @discardableResult
    func caseIs<T: MessageProtocol>(_ type: T.Type, perform: (_ message: T) -> Void) -> [String: Any] {

        guard self.keys.first == "\(T.self)" else { return self }
        guard let content = self.first?.value else { return self }

        if let jsonData = try? JSONSerialization.data(withJSONObject: content),
            let decoded = try? JSONDecoder().decode(T.self, from: jsonData) {
            perform(decoded)
        }

        return self
    }
}

public protocol MessageProtocol: Codable {

}

public extension MessageProtocol {

    var type: String {
        return "\(Self.self)"
    }

    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }

    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }

}

public extension Data {
    @discardableResult
    func caseIs<T: MessageProtocol>(_ type: T.Type, perform: (_ message: T) -> Void) -> Data {
        if let decoded = try? JSONDecoder().decode(T.self, from: self), decoded.type == "\(T.self)" {
            print("DECODED TYPE: \(decoded.type) -- T.self: \(T.self)")
            perform(decoded)
        }
        return self
    }

    func decode<T: Message>() -> T? {
        let dataSize = MemoryLayout<T>.size
        guard self.count == dataSize else {
            return nil
        }

        let d = self as NSData
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: dataSize)
        d.getBytes(pointer, length: dataSize)
        return pointer.move()
    }
}

public protocol Message { }

public extension Message {
    func encode() -> Data {
        var value = self
        return Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
    }
}
