# MultiplayerKit

[![Version](https://img.shields.io/cocoapods/v/MultiplayerKit.svg?style=flat)](https://cocoapods.org/pods/MultiplayerKit)
[![License](https://img.shields.io/cocoapods/l/MultiplayerKit.svg?style=flat)](https://cocoapods.org/pods/MultiplayerKit)
[![Platform](https://img.shields.io/cocoapods/p/MultiplayerKit.svg?style=flat)](https://cocoapods.org/pods/MultiplayerKit)

MultiplayerKit is a framework that facilitates Multiplayer Games development in iOS Devices.

## Requirements
- iOS 12.0 +
- Game Center Capability
- Your game must be registered in [App Store Connect](https://appstoreconnect.apple.com)
- Create at least one leaderborard for your game in App Store Connect, even if you will not use(Its necessary to associate the game to bundle id).


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

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
        view?.presentScene(GameScene(), transition: .crossFade(withDuration: 1.0))
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
In `willStartGame()` method present the scene:

```swift
func willStartGame() {
    view?.presentScene(GameScene(), transition: .crossFade(withDuration: 1.0))
}
```

To present matchmaker, call the function presentMatchmaker in MenuScene, or associate to a button action. Example:

```swift
startButton.actionBlock = presentMatchMaker
```

After Game Scene conforms to MKGameScene, you must associate the scene:

```swift
override func didMove(to view: SKView) {
    multiplayerService.gameScene = self
    //...
}
```

You can access all player in the match through `multiplayerService.players`. Example allocating all players in the scene:

```swift
func setupPlayers() {
    //...
    multiplayerService.players.forEach {
        let player = SpaceShip(gkPlayer: $0, texture: SKTexture(imageNamed: "ship"))
        allPlayersNode[$0] = player
        addChild(player)
    }
}
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
let position = Position(point: position, angle: angle)
multiplayerService.send(position)
```

# Receive Messages

The method `didReceive(message: Message, from player: GKPlayer)` in GameScene is responsable to receive all messages. Example, with `Position`, `Attack` and `StartGame` messages:

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

## Credits

Artwork in demo project created by Luis Zuno (@ansimuz)

## License

MultiplayerKit is available under the MIT license. See the LICENSE file for more info.
