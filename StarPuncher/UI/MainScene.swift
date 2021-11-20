import SpriteKit

class MainScene: SKScene {
    lazy var playerParts: [Joint.Name: SKShapeNode] = [.nose: nose,
                                                       .rightEye: eye,
                                                       .leftEye: eye,
                                                       .rightShoulder: joint,
                                                       .leftShoulder: joint,
                                                       .rightElbow: joint,
                                                       .leftElbow: joint,
                                                       .rightWrist: fist,
                                                       .leftWrist: fist,
                                                       .rightEar: ear,
                                                       .leftEar: ear]
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
        spaceBackground?.position = CGPoint(x: scene?.size.height ?? 700, y: 0.0)
        scene?.addChild(spaceBackground!)
        playerParts.values.forEach { self.scene?.addChild($0)}
        
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
    
    var fist: SKShapeNode {
        let fistSize = 10.0
        let node = SKShapeNode(circleOfRadius: fistSize)
        node.fillColor = .red
        node.name = "fist"
        node.physicsBody = SKPhysicsBody(circleOfRadius: fistSize)
        node.physicsBody?.contactTestBitMask = 1
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        return node
    }
    
    
    
    func drawPlayer(pose: Pose) {
        guard pose.confidence > 0.05 else {
            return
        }
        pose.joints.forEach({ (key: Joint.Name, value: Joint) in
            if let node = playerParts[key] {
                node.position = CGPoint(x: ((scene?.size.width ?? 0) - value.position.x), y: value.position.y)
                node.isHidden = !value.isValid
            }
        })
    }
}

extension MainScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" && nodeB.name == "fist"{
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.position = nodeA.position
            scene?.addChild(explosion!)
            nodeA.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
//            score += 1
//            scoreLabel.text = "\(score)"
            
        } else if nodeB.name == "ball" && nodeA.name == "fist" {
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.position = nodeB.position
            scene?.addChild(explosion!)
            nodeB.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
//            score += 1
//            scoreLabel.text = "\(score)"
        }
    }
}
