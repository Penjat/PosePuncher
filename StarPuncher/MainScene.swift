import SpriteKit

class MainScene: SKScene, SKPhysicsContactDelegate {
    lazy var playerParts: [Joint.Name: SKShapeNode] = [.nose: nose,
                                                  .rightEye: eye,
                                                  .leftEye: eye,
                                                       .rightShoulder: joint,
                                                       .leftShoulder: joint,
                                                       .rightElbow: joint,
                                                       .leftElbow: joint,
                                                       .rightWrist: joint,
                                                       .leftWrist: joint,
                                                       .rightEar: ear,
                                                       .leftEar: ear]
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
        spaceBackground?.position = CGPoint(x: 700, y: 0.0)
        scene?.addChild(spaceBackground!)
        
        playerParts.values.forEach { self.scene?.addChild($0)}
    }
    
    var nose: SKShapeNode {
        let node = SKShapeNode(circleOfRadius: 5)
        node.fillColor = .blue
        return node
    }
    
    var eye: SKShapeNode {
        let node = SKShapeNode(circleOfRadius: 8)
        node.fillColor = .green
        return node
    }
    
    var ear: SKShapeNode {
        let node = SKShapeNode(rectOf: CGSize(width: 4, height: 8))
        node.fillColor = .red
        return node
    }
    
    var joint: SKShapeNode {
        let node = SKShapeNode(circleOfRadius: 5)
        node.fillColor = .blue
        return node
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
    }
    
    func drawPlayer(pose: Pose) {
        guard pose.confidence > 0.05 else {
            return
        }
        pose.joints.forEach({ (key: Joint.Name, value: Joint) in
            if let node = playerParts[key], value.isValid {
                node.position = value.position
            }
        })
    }
}
