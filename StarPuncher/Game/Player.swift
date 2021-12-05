import SpriteKit

protocol Player {
    func drawPlayer(pose: Pose, scene: SKScene)
    func setUp(scene: SKScene)
    var playerSize: CGSize { get }
}

struct JointSegment: Hashable {
    let jointA: Joint.Name
    let jointB: Joint.Name
}

class PersonPlayer: Player {
    var playerSize: CGSize {
        CGSize(width: 200, height: 200)
    }
    
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
    
    let rocketTrail = SKEmitterNode(fileNamed: "RocketTrail")!
    
    func setUp(scene: SKScene) {
//        playerParts.values.forEach { scene.addChild($0)}
//        jointSegments.values.forEach { scene.addChild($0)}
//        rocketTrail.targetNode = scene
//        scene.addChild(rocketTrail)
        let circle = SKShapeNode(circleOfRadius: 100)
        circle.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        
        scene.addChild(circle)
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
    
    func drawPlayer(pose: Pose, scene: SKScene) {
        guard pose.confidence > 0.05 else {
            return
        }
        pose.joints.forEach({ (key: Joint.Name, value: Joint) in
            if let node = playerParts[key] {
                node.position = CGPoint(x: ((scene.size.width) - value.position.x), y: value.position.y)
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

