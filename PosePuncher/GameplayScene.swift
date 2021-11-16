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
        
        physicsWorld.contactDelegate = self
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
        spaceBackground?.position = CGPoint(x: 700, y: 0.0)
        scene?.addChild(spaceBackground!)
    }
    
    func setUp() {
        videoViewModel.checkAuthorization()
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
        let update = SKAction.run(
        {
            let shape = SKShapeNode(path: Star(corners: 5, smoothness: 0.5).path(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 25, height: 25))) )
            shape.position = CGPoint(x: CGFloat.random(in: 30..<(self.scene?.frame.maxX ?? 300)-30), y:-50)
//            shape.fillColor = .orange
            shape.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            shape.physicsBody?.isDynamic = true
            shape.physicsBody?.affectedByGravity = false
            shape.name = "ball"
            shape.physicsBody!.contactTestBitMask = 1
            let moveAction = SKAction.moveTo(y: (self.scene?.frame.maxY ?? 300) + 50, duration: 10.0)
            let rotateAction =
            SKAction.repeatForever(SKAction.rotate(byAngle: 3.1, duration: 2))
            let action = SKAction.group([rotateAction,moveAction])
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
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.position = nodeA.position
            scene?.addChild(explosion!)
            nodeA.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
            score += 1
            scoreLabel.text = "\(score)"
            
        } else if nodeB.name == "ball" && nodeA.name == "fist" {
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.position = nodeB.position
            scene?.addChild(explosion!)
            nodeB.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
            score += 1
            scoreLabel.text = "\(score)"
        }
    }
}
