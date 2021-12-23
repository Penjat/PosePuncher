import SpriteKit
import Combine

class MainScene: SKScene, ObservableObject {
    let starLoopKey = "STAR-LOOP-KEY"
    let starSpeed = 7.0
    var score = 0
    let player: Player = RectPlayer()//PersonPlayer()
    var bag = Set<AnyCancellable>()
    let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
//    let textTyper = TextInputPresenter()  
    let label = SKLabelNode()
    
    let nodeProvider = NodeProvider()
    @Published var typedText = ""
    
    override func didMove(to view: SKView) {
        setUpScene()
    }
    
    func setUpScene() {
        physicsWorld.contactDelegate = self
        player.setUp(scene: self)
        
        spaceBackground?.position = CGPoint(x: (scene?.size.width ?? 700)/2, y: 0.0)
        spaceBackground?.particlePositionRange = CGVector(dx: scene?.size.width ?? 100, dy: 1)
        spaceBackground?.advanceSimulationTime(9.0)
        scene?.addChild(spaceBackground!)
        
        scene?.addChild(label)
        label.zRotation = CGFloat.pi
        label.position = CGPoint(x: (scene?.size.width ?? 0)/2, y: 200.0)
        startGame()
    }
    
    func startGame() {
        run(starfallLoop, withKey: starLoopKey)
        
        player.playerStats.$health.sink { health in
            if health <= 0 {
                self.gameOver()
            }
        }.store(in: &bag)
    }
    
    func gameOver() {
        self.removeAction(forKey: self.starLoopKey)
        
        scene?.addChild(gameoverLabel)
    }
    
    var gameoverLabel: SKNode {
        let button = SKLabelNode(text: "GAME OVER")
        button.fontName = "ArcadeClassic"
        button.fontSize = 30
        button.zRotation = Double.pi
        
        button.position = CGPoint(x: scene?.frame.midX ?? 0, y: -50)
        let moveAction = SKAction.moveTo(y: (scene?.frame.maxY ?? 0), duration: starSpeed*2)
        button.run(moveAction)
        
        button.physicsBody = SKPhysicsBody(rectangleOf: button.frame.size)
        button.physicsBody!.contactTestBitMask = 0x00000101
        button.physicsBody!.categoryBitMask = 0x00000010
        button.physicsBody!.collisionBitMask = 0x00000101
        button.physicsBody?.affectedByGravity = false
        button.physicsBody?.isDynamic = true
        
        return button
    }
    
    
    
    func enterHighScore() {
        //        scene?.addChild(textTyper.node)
        //        textTyper.node.position = CGPoint(x: (scene?.size.width ?? 0.0)/2.0, y: (scene?.size.height ?? 0.0)/2.0)
        
        //        $typedText.sink { newText in
        //            self.label.text = newText
        //        }.store(in: &bag)
    }
    
    var starfallLoop: SKAction {
        let update = SKAction.run(
            {
                self.nodeProvider.addRandomStars(to: self)
            })
        
        let seq = SKAction.sequence([SKAction.wait(forDuration: 0.5),update])
        return SKAction.repeatForever(seq)
    }
    
    var starcircleLoop: SKAction {
        let update = SKAction.run(
            {
                let shape = SKShapeNode(path: Star(corners: 5, smoothness: 0.6).path(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 25, height: 25))) )
                let radius: CGFloat = 1200
                let theta = CGFloat.random(in: 0..<1) * CGFloat.pi * 2.0
                shape.position = CGPoint(x: cos(theta)*radius+(self.scene?.size.width ?? 2)/2, y:sin(theta)*radius+(self.scene?.size.height ?? 2)/2)
                
                shape.fillColor = .yellow
                shape.lineWidth = 0
                shape.physicsBody = SKPhysicsBody(circleOfRadius: 25)
                shape.physicsBody?.isDynamic = true
                shape.physicsBody?.affectedByGravity = false
                shape.name = "ball"
                shape.physicsBody!.contactTestBitMask = 1
                let moveXAction = SKAction.moveTo(x: (self.scene?.size.width ?? 2)/2, duration: self.starSpeed)
                let moveYAction = SKAction.moveTo(y: (self.scene?.size.height ?? 2)/2, duration: self.starSpeed)
                let rotateAction =
                SKAction.repeatForever(SKAction.rotate(byAngle: Double.pi, duration: 2))
                let action = SKAction.group([rotateAction, moveXAction, moveYAction])
                shape.run(action)
                self.addChild(shape)
            })
        
        let seq = SKAction.sequence([SKAction.wait(forDuration: 2),update])
        return SKAction.repeatForever(seq)
    }
}

extension MainScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        if let (ball, fist) = checkCollision("ball", "fist")  as? (SKNode, SKShapeNode) {
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.position = ball.position
            explosion?.particleColorSequence = nil
            explosion?.particleColorBlendFactor = 1.0
            if let shape = ball.childNode(withName: "shape") as? SKShapeNode {
                explosion?.particleColor = shape.fillColor
            }
            scene?.addChild(explosion!)
            ball.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
            score += 1
        }
        
        if let (heart, ball) = checkCollision("heart", "ball") {
            guard player.playerStats.health > 0 else {
                return
            }
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.particleColorSequence = nil
            explosion?.particleColorBlendFactor = 1.0
            if let shape = ball.childNode(withName: "shape") as? SKShapeNode {
                explosion?.particleColor = shape.fillColor
            }
            
            player.playerStats.health -= 1
            
            if player.playerStats.health <= 0, let scene = scene {
                let playerExplosion = SKEmitterNode(fileNamed: "PlayerExplode")
                playerExplosion?.position = CGPoint(x: scene.frame.midX + heart.position.x, y: scene.frame.midY + heart.position.y)
                scene.addChild(playerExplosion!)
            }
            explosion?.position = ball.position
            scene?.addChild(explosion!)
            ball.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
        }
        
        if let (letter, fist) = checkCollision("letterNode", "fist") as? (SKShapeNode, SKShapeNode) {
            if let char = letter.userData?["letter"] as? String {
                typedText += char
            }
        }
        
        func checkCollision(_ nameA: String, _ nameB: String) -> (SKNode, SKNode)? {
            switch (nodeA.name, nodeB.name){
            case (nameA, nameB):
                return (nodeA, nodeB)
            case (nameB, nameA):
                return (nodeB, nodeA)
            default:
                return nil
            }
        }
    }
}
