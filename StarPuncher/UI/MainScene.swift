import SpriteKit

struct JointSegment: Hashable {
    let jointA: Joint.Name
    let jointB: Joint.Name
}

class MainScene: SKScene {
    var score = 0
    let scoreLabel = SKLabelNode(text: "0")
    let rocketTrail = SKEmitterNode(fileNamed: "RocketTrail")!
       
    lazy var jointSegments = [
        // The connected joints that are on the left side of the body.
        JointSegment(jointA: .leftHip, jointB: .leftShoulder): bodyLine,
        JointSegment(jointA: .leftShoulder, jointB: .leftElbow): bodyLine,
        JointSegment(jointA: .leftElbow, jointB: .leftWrist): bodyLine,
        //        JointSegment(jointA: .leftHip, jointB: .leftKnee),
        //        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
        //        // The connected joints that are on the right side of the body.
        JointSegment(jointA: .rightHip, jointB: .rightShoulder): bodyLine,
        JointSegment(jointA: .rightShoulder, jointB: .rightElbow): bodyLine,
        JointSegment(jointA: .rightElbow, jointB: .rightWrist): bodyLine,
        //        JointSegment(jointA: .rightHip, jointB: .rightKnee),
        //        JointSegment(jointA: .rightKnee, jointB: .rightAnkle),
        // The connected joints that cross over the body.
        JointSegment(jointA: .leftShoulder, jointB: .rightShoulder): bodyLine,
        JointSegment(jointA: .leftHip, jointB: .rightHip): bodyLine
    ]
    
    lazy var playerParts: [Joint.Name: SKShapeNode] = [.nose: nose,
                                                       .rightEye: eye,
                                                       .leftEye: eye,
                                                       .rightShoulder: joint,
                                                       .leftShoulder: joint,
                                                       .rightElbow: joint,
                                                       .leftElbow: joint,
                                                       .rightHip: joint,
                                                       .leftHip: joint,
                                                       .rightWrist: fist,
                                                       .leftWrist: fist,
                                                       .rightEar: ear,
                                                       .leftEar: ear]
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
        spaceBackground?.position = CGPoint(x: scene?.size.width ?? 700, y: 0.0)
        spaceBackground?.advanceSimulationTime(9.0)
        scene?.addChild(spaceBackground!)
        playerParts.values.forEach { self.scene?.addChild($0)}
        jointSegments.values.forEach { self.scene?.addChild($0)}
        
        rocketTrail.targetNode = scene
        scene?.addChild(rocketTrail)
        
        scoreLabel.fontSize = 65
        scoreLabel.fontColor = SKColor.green
        scoreLabel.position = CGPoint(x: 80, y: 80)
        scoreLabel.zRotation = 3.14159
        addChild(scoreLabel)
        
        let update = SKAction.run(
            {
                let shape = SKShapeNode(path: Star(corners: 5, smoothness: 0.5).path(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 25, height: 25))) )
                shape.position = CGPoint(x: CGFloat.random(in: 30..<(self.scene?.frame.maxX ?? 300)-30), y:-50)
                shape.fillColor = .yellow
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
    
    var bodyLine: SKShapeNode {
        let line = SKShapeNode()
        
        line.strokeColor = SKColor.white
        line.lineWidth = 4
        return line
    }
    
    var nose: SKShapeNode {
        let node = SKShapeNode(circleOfRadius: 50)
        node.lineWidth = 4
        node.strokeColor = .white
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
        node.fillColor = .white
        return node
    }
    
    var fist: SKShapeNode {
        let fistSize = 16.0
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
        
        jointSegments.forEach { (key: JointSegment, value: SKShapeNode) in
            guard pose.joints[key.jointA]?.isValid ?? false, pose.joints[key.jointB]?.isValid ?? false else {
                return
            }
            
            let jointA = playerParts[key.jointA]
            let jointB = playerParts[key.jointB]
            
            let path = CGMutablePath()
            path.move(to: jointA!.position )
            path.addLine(to: jointB!.position)
            value.path = path
        }
        
        if pose.joints[.rightHip]?.isValid ?? false && pose.joints[.leftHip]?.isValid ?? false, let hip1 = playerParts[.leftHip]?.position, let hip2 = playerParts[.rightHip]?.position {
            rocketTrail.position = hip1.midBetween(hip2)
            rocketTrail.particleBirthRate = 30
        } else {
            rocketTrail.particleBirthRate = 0
        }
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
