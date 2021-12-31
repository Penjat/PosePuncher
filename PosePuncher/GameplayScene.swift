import SpriteKit
import Combine
import SwiftUI

// A simple game scene with falling boxes
class GameScene: SKScene, SKPhysicsContactDelegate {
    @ObservedObject var videoViewModel = ContentViewModel()
    @ObservedObject var poseViewModel = PoseViewModel()
    
    var score = 0
    let scoreLabel = SKLabelNode(text: "0")
    
    var player: RocketController?
    var rightHand: SKEmitterNode?
    var leftHand: SKShapeNode?
    
    var colorValue = NSColor.green
    override func didMove(to view: SKView) {
//        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
//        spaceBackground?.position = CGPoint(x: 700, y: 0.0)
//        scene?.addChild(spaceBackground!)
    }
    
    func setUp() {
//        videoViewModel.checkAuthorization()
        videoViewModel.setupOutput(delgate: poseViewModel)
        
        player = RocketController(particleTarget: self)
        scene?.addChild(player!.playerBody)
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        scoreLabel.fontSize = 65
        scoreLabel.fontColor = SKColor.green
        scoreLabel.position = CGPoint(x: 80, y: 80)
        scoreLabel.zRotation = 3.14159
        addChild(scoreLabel)
        
        player?.setUpSink(posePublisher: poseViewModel.pose.eraseToAnyPublisher())
        
    }
}
