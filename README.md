# MultiplayerKit

[![Version](https://img.shields.io/cocoapods/v/MultiplayerKit.svg?style=flat)](https://cocoapods.org/pods/MultiplayerKit)
[![License](https://img.shields.io/cocoapods/l/MultiplayerKit.svg?style=flat)](https://cocoapods.org/pods/MultiplayerKit)
[![Platform](https://img.shields.io/cocoapods/p/MultiplayerKit.svg?style=flat)](https://cocoapods.org/pods/MultiplayerKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MultiplayerKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MultiplayerKit'
```
## Setup
First need to make Menu Scene and Game Scene comform to protocols MKMenuScene and MKGameScene. Example:

```swift
final class MenuScene: SKScene, MKMenuScene {
    var matchmaker: Matchmaker?
    
    func didAuthenticationChanged(to state: Matchmaker.AuthenticationState) {
        
    }
    
    func willStartGame() {
        //Presenting Scene example:
        view?.presentScene(GameScene(), transition: SKTransition.crossFade(withDuration: 1.0))
    }
}

class GameScene: SKScene, MKGameScene {
    var multiplayerService: MultiplayerService 
    func didReceive(message: Message, from player: GKPlayer) {
        //Your Implementation
    }
    
    func didPlayerConnected() {
        //Your Implementation
    }
}
```
```diff
! MenuScene must be final class
```

In GameViewController instantiate the Matchmaker and Menu Scene

```swift
if let skView = view as? SKView {
  let matchmaker = Matchmaker(authenticationViewController: self)
  let menuScene = MenuScene(matchmaker: matchmaker)
  skView.presentScene(menuScene)
}
```

## Create custom messages

Create a struct that conforms to Message protocol. Example:

```swift
struct Position: Message {
    var point: CGPoint, angle: CGFloat
}
```

# Send Messages

In your GameScene call the method `send(_ message: Message)` of MultiplayerService. Example:

```swift
let position = Position(point: playerPosition, angle: playerAngle)
multiplayerService.send(position)
```

# Receive Messages

The method `didReceive(message: Message, from player: GKPlayer)` in GameScene is responsable to receive all messages. Example:

```swift
  func didReceive(message: Message, from player: GKPlayer) {
        guard let playerNode = allPlayersNode[player] else { return }
        switch message {
        case let position as Position:
            playerNode.changePlayer(position: position.point, angle: position.angle)
        case let startGame as StartGame:
            //Start game Logic
        case let attack as Attack:
            //Player attack Logic
        default:
            break
        }
    }
```

## Author

jonhpol, j.paulo_os@hotmail.com

## License

MultiplayerKit is available under the MIT license. See the LICENSE file for more info.
