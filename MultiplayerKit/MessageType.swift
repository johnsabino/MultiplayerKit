public struct Position: MessageProtocol {
    public var x: CGFloat, y: CGFloat, angle: CGFloat

    public init(x: CGFloat, y: CGFloat, angle: CGFloat) {
        self.x = x
        self.y = y
        self.angle = angle
    }
}

public struct Message<T: MessageProtocol> {
    let type: T

    enum CodingKeys: String, CodingKey {
        case type = "Type"
    }

    init(from decoder: Decoder) throws {
        print("\(T.self)")
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(T.self, forKey: .type)
    }
}
