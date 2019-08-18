public extension Data {
    @discardableResult
    func caseIs<T: MessageProtocol>(_ type: T.Type, doThis: (T) -> Void) -> Data {
        if let set = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
            if (set["type"] as? String) != "\(T.self)" {
                print((set["type"] as? String), "é diferente de: \(T.self)" )
                return self
                
            }
        }
        
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
        var dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        dict["type"] = "\(Self.self)"
        return dict
    }
    
}
