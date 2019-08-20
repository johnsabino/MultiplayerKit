public struct Position: MessageProtocol {
    public var positionX: CGFloat, positionY: CGFloat, angle: CGFloat
    
    public init(positionX: CGFloat, positionY: CGFloat, angle: CGFloat) {
        self.positionX = positionX
        self.positionY = positionY
        self.angle = angle
    }
}
