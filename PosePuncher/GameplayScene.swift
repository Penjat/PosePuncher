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
        let update = SKAction.run(
        {
            let shape = SKShapeNode(circleOfRadius: 30 )
            shape.position = CGPoint(x: CGFloat.random(in: 30..<(self.scene?.frame.maxX ?? 300)-30), y:-50)
            shape.fillColor = .blue
    //        shape.lineWidth = 10
            shape.physicsBody = SKPhysicsBody(circleOfRadius: 30)
            shape.physicsBody?.isDynamic = false
            shape.physicsBody?.affectedByGravity = false
            shape.name = "ball"
            shape.physicsBody!.contactTestBitMask = 1
            let action = SKAction.moveTo(y: (self.scene?.frame.maxY ?? 300) + 50, duration: 10.0)
            shape.run(action)
            self.addChild(shape)
        })
        
        let seq = SKAction.sequence([SKAction.wait(forDuration: 2),update])
        let createLoop = SKAction.repeatForever(seq)
        run(createLoop)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" && nodeB.name == "fist"{
            nodeA.removeFromParent()
            
            print("ball")
        } else if nodeB.name == "ball" && nodeA.name == "fist" {
            nodeB.removeFromParent()
            print("ball")
        }
    }
}
