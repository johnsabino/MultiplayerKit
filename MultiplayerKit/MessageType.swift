public struct Position: MessageProtocol {
    public var x: CGFloat, y: CGFloat, angle: CGFloat

    public init(x: CGFloat, y: CGFloat, angle: CGFloat) {
        self.x = x
        self.y = y
        self.angle = angle
    }
}
