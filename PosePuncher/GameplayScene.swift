import SpriteKit
import Combine
import SwiftUI

// A simple game scene with falling boxes
class GameScene: SKScene, SKPhysicsContactDelegate {
    @ObservedObject var videoViewModel = ContentViewModel()
    @ObservedObject var poseViewModel = PoseViewModel()
    
    let player = PlayerController()
    var rightHand: SKEmitterNode?
    var leftHand: SKShapeNode?
    
    var colorValue = NSColor.green
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
    }
    
    func setUp() {
        videoViewModel.checkAuthorization()
        videoViewModel.setupOutput(delgate: poseViewModel)
        scene?.addChild(player.playerBody)
        
        player.setUpSink(posePublisher: poseViewModel.pose.eraseToAnyPublisher())
        
        let shape = SKShapeNode(circleOfRadius: 50 )
        shape.position = CGPoint(x: 600, y:300)
        shape.fillColor = .blue
        shape.lineWidth = 10
        shape.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        shape.physicsBody?.isDynamic = false
        shape.physicsBody?.affectedByGravity = false
        shape.name = "ball"
        shape.physicsBody!.contactTestBitMask = 1
        addChild(shape)
        
        let shape2 = SKShapeNode(circleOfRadius: 50 )
        shape2.position = CGPoint(x: (scene?.frame.maxX ?? 0) - 300, y: 300)
        shape2.fillColor = .green
        shape2.lineWidth = 10
        shape2.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        shape2.physicsBody?.isDynamic = false
        shape2.physicsBody?.affectedByGravity = false
        shape2.name = "ball2"
        shape2.physicsBody!.contactTestBitMask = 1
        addChild(shape2)        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball2" || nodeB.name == "ball2" {
            player.rightWrist?.fillColor = .green
            player.leftWrist?.fillColor = .green
            
            print("ball 2")
        } else if nodeA.name == "ball" || nodeB.name == "ball" {
            player.rightWrist?.fillColor = .blue
            player.leftWrist?.fillColor = .blue
            print("ball 1")
        }
    }
}
