public extension Data {
    @discardableResult
    func caseIs<T: MessageProtocol>(_ type: T.Type, perform: (_ message: T) -> Void) -> Data {
        if let set = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
            if (set["type"] as? String) != "\(T.self)" { return self }
        }
        if let decoded = try? JSONDecoder().decode(T.self, from: self) {
            perform(decoded)
        }
        return self
    }
}

public extension Dictionary where Key == String {
    @discardableResult
    func caseIs<T: MessageProtocol>(_ type: T.Type, perform: (_ message: T) -> Void) -> [String: Any] {
        
        guard let content = self.first?.value, self.keys.first == "\(T.self)" else { return self }
        
        if let data = try? JSONSerialization.data(withJSONObject: content, options: .prettyPrinted) {
            if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                perform(decoded)
            }
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
        return dict
    }
    
}
