public struct StartGame: MessageProtocol {
    public init() {
        
    }
}
public struct Position: MessageProtocol {
    var positionX: CGFloat, positionY: CGFloat, angle: CGFloat
    
    public init(positionX: CGFloat, positionY: CGFloat, angle: CGFloat) {
        self.positionX = positionX
        self.positionY = positionY
        self.angle = angle
    }
}
public struct Attack: MessageProtocol {
    public init() {
        
    }
}
public struct Hitted: MessageProtocol {
    public init() {
        
    }
}
