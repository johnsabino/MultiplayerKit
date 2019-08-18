public extension Data {
    @discardableResult
    func caseIs<T: MessageProtocol>(_ type: T.Type, doThis: (T) -> Void) -> Data {
        if let decoded = try? JSONDecoder().decode(T.self, from: self) {
            doThis(decoded)
        }
        return self
    }
}

public protocol MessageProtocol: Codable {
    
}

public extension MessageProtocol {
    
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        //dict["type"] = "\(Self.self)"
        return dict
    }
    
}
