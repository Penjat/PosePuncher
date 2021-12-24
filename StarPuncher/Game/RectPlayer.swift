import SpriteKit
import Combine

class RectPlayer: Player {
    var bag = Set<AnyCancellable>()
    var playerSize: CGSize {
        CGSize(width: 400, height: 400)
    }
    let playerStats = PlayerStats()
    var playerBody: SKShapeNode?
    
    lazy var playerParts: [Joint.Name: SKShapeNode] = [.leftWrist: fist,
                                                       .rightWrist: fist,
                                                       .nose: playerHeart,
                                                       .leftElbow: smallJoint,
                                                       .rightElbow: smallJoint,
                                                       .leftShoulder: smallJoint,
                                                       .rightShoulder: smallJoint]
    
    lazy var jointSegments = [
        // The connected joints that are on the left side of the body.
//        JointSegment(jointA: .leftHip, jointB: .leftShoulder): bodyLine,
        JointSegment(jointA: .leftShoulder, jointB: .leftElbow): bodyLine,
        JointSegment(jointA: .leftElbow, jointB: .leftWrist): bodyLine,
        //        JointSegment(jointA: .leftHip, jointB: .leftKnee),
        //        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
        //        // The connected joints that are on the right side of the body.
//        JointSegment(jointA: .rightHip, jointB: .rightShoulder): bodyLine,
        JointSegment(jointA: .rightShoulder, jointB: .rightElbow): bodyLine,
        JointSegment(jointA: .rightElbow, jointB: .rightWrist): bodyLine,
        //        JointSegment(jointA: .rightHip, jointB: .rightKnee),
        //        JointSegment(jointA: .rightKnee, jointB: .rightAnkle),
        // The connected joints that cross over the body.
        JointSegment(jointA: .leftShoulder, jointB: .rightShoulder): bodyLine,
//        JointSegment(jointA: .leftHip, jointB: .rightHip): bodyLine
    ]
    
    var bodyLine: SKShapeNode {
        let line = SKShapeNode()
        
        line.strokeColor = SKColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
        
        line.lineWidth = 4
        return line
    }
    
    func flashHeart() {
        let repeatTime: CGFloat = 0.1
        let repeats = 6
        let flash = SKAction.sequence([
            SKAction.run { self.playerHeart.fillColor = .systemPink},
            SKAction.wait(forDuration: repeatTime),
            SKAction.run { self.playerHeart.fillColor = .white},
            SKAction.wait(forDuration: repeatTime)])
        let repeatAction = SKAction.repeat(flash, count: repeats)
        
        
        playerHeart.run(repeatAction)
    }
    
    var smallJoint: SKShapeNode {
        let jointSize = 8.0
        let node = SKShapeNode(circleOfRadius: jointSize)
        node.lineWidth = 0
        node.fillColor = .white
        return node
    }
    
    var fist: SKShapeNode {
        let fistSize = 16.0
        let node = SKShapeNode(circleOfRadius: fistSize)
        node.lineWidth = 0
        node.fillColor = .white
        node.name = "fist"
        node.physicsBody = SKPhysicsBody(circleOfRadius: fistSize)
        node.physicsBody?.categoryBitMask = 0x00000001
        node.physicsBody?.contactTestBitMask = 0x00000001
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        return node
    }
    
    func drawPlayer(pose: Pose, scene: SKScene) {
        self.playerBody?.strokeColor = (pose.confidence > 0.5) ? UIColor.green : .red
        pose.joints.forEach({ (key: Joint.Name, value: Joint) in
            if let node = playerParts[key] {
                node.position = CGPoint(x: playerSize.width/2-value.position.x, y: value.position.y-playerSize.height/2)
                node.isHidden = !value.isValid
            }
        })
        
        jointSegments.forEach { (key: JointSegment, lineNode: SKShapeNode) in
            guard
                pose.joints[key.jointA]?.isValid ?? false,
                pose.joints[key.jointB]?.isValid ?? false,
                let jointA = playerParts[key.jointA],
                let jointB = playerParts[key.jointB] else {
                    lineNode.isHidden = true
                    return
            }
            lineNode.isHidden = false
            let path = CGMutablePath()
            path.move(to: jointA.position )
            path.addLine(to: jointB.position)
            lineNode.path = path
        }
        
        playerParts[.nose]?.isHidden = playerStats.health <= 0
    }
    
    var playerHeart: SKShapeNode = {
        let heartSize: CGFloat = 30
        let heart = SKShapeNode(circleOfRadius: heartSize)
        heart.physicsBody = SKPhysicsBody(circleOfRadius: heartSize)
        heart.physicsBody?.contactTestBitMask = 0x00000010
        heart.physicsBody?.categoryBitMask = 0x00000100
        heart.physicsBody?.collisionBitMask = 0x00000010
        heart.physicsBody?.affectedByGravity = false
        heart.physicsBody?.isDynamic = false
        heart.fillColor = .white
        heart.name = "heart"
        return heart
    }()
    
    func setUp(scene: SKScene) {
        playerBody = SKShapeNode(rectOf: playerSize)
        playerBody?.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        scene.addChild(playerBody!)
        
        playerParts.values.forEach { playerBody?.addChild($0)}
        jointSegments.values.forEach { playerBody?.addChild($0)}
        
        playerStats.$health.receive(on: RunLoop.main).scan(playerStats.health) { $0 - $1 }.sink { changeInHealth in
            if changeInHealth < 0 {
                self.flashHeart()
            }
        }.store(in: &bag)
    }
    
    
}
