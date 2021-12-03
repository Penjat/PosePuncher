import SpriteKit

class RectPlayer: Player {
    var playerSize: CGSize {
        CGSize(width: 400, height: 400)
    }
    
    var playerBody: SKShapeNode?
    
    lazy var playerParts: [Joint.Name: SKShapeNode] = [.leftWrist: fist,
                                                       .rightWrist: fist]
    
    var fist: SKShapeNode {
        let fistSize = 16.0
        let node = SKShapeNode(circleOfRadius: fistSize)
        node.lineWidth = 0
        node.fillColor = .red
        node.name = "fist"
        node.physicsBody = SKPhysicsBody(circleOfRadius: fistSize)
        node.physicsBody?.contactTestBitMask = 1
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
    }
    
    var playerHeart: SKShapeNode = {
        let heartSize: CGFloat = 30.0
        let heart = SKShapeNode(circleOfRadius: heartSize)
        heart.physicsBody = SKPhysicsBody(circleOfRadius: heartSize)
        heart.physicsBody?.contactTestBitMask = 1
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
        playerBody?.addChild(playerHeart)
        
        playerParts.values.forEach { playerBody?.addChild($0)}
    }
}
