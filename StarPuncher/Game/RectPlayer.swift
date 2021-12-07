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
                                                       .rightWrist: fist]
    
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
    
    var fist: SKShapeNode {
        let fistSize = 16.0
        let node = SKShapeNode(circleOfRadius: fistSize)
        node.lineWidth = 0
        node.fillColor = .red
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
    }
    
    var playerHeart: SKShapeNode = {
        let heartSize: CGFloat = 30
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
        
        playerStats.$health.receive(on: RunLoop.main).scan(playerStats.health) { $0 - $1 }.sink { changeInHealth in
            if changeInHealth < 0 {
                self.flashHeart()
            }
        }.store(in: &bag)
    }
}
