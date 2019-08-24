public extension Dictionary where Key == String {
    @discardableResult
    func caseIs<T: MessageProtocol>(_ type: T.Type, perform: (_ message: T) -> Void) -> [String: Any] {

        guard
            let content = self.first?.value, self.keys.first == "\(T.self)"
        else {
            return self
        }

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

    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }

    func returnSelf() {

    }

}

public func encode<T>( value: T) -> Data {
    var v = value
    //    let data = withUnsafeMutablePointer(to: &v) { p in
    //        NSData(bytes: p, length: MemoryLayout.size(ofValue: v))
    //    }
    //    let data = withUnsafePointer { p in
    //        NSData(bytes: p, length: MemoryLayout.size(ofValue: v))
    //    }
    return Data(bytes: &v, count: MemoryLayout.size(ofValue: v))
}

public func decode<T>(data: Data) -> T {
    let dataSize = MemoryLayout<T>.size
    guard data.count == dataSize else {
        fatalError()
    }
    
    let d = data as NSData
    let pointer = UnsafeMutablePointer<T>.allocate(capacity: dataSize)
    d.getBytes(pointer, length: dataSize)
    return pointer.move()
}

public protocol Msg { }

public enum Message: Msg {
    case move(pos: CGPoint, angle: CGFloat)
    case message(msg: String)
}
