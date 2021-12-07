import SpriteKit
import Combine

class MainScene: SKScene {
    let starLoopKey = "STAR-LOOP-KEY"
    var score = 0
    let player: Player = RectPlayer()//PersonPlayer()
    var bag = Set<AnyCancellable>()
    let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
    let textTyper = TextInputPresenter()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        spaceBackground?.position = CGPoint(x: (scene?.size.width ?? 700)/2, y: 0.0)
        spaceBackground?.particlePositionRange = CGVector(dx: scene?.size.width ?? 100, dy: 1)
        spaceBackground?.advanceSimulationTime(9.0)
        
        
        player.setUp(scene: self)
        scene?.addChild(textTyper.node)
        textTyper.node.position = CGPoint(x: (scene?.size.width ?? 0.0)/2.0, y: (scene?.size.height ?? 0.0)/2.0)
//        run(starcircleLoop, withKey: starLoopKey)
        
        scene?.addChild(spaceBackground!)
        
        player.playerStats.$health.sink { health in
//            self.scene?.isPaused = (health <= 0)
            if health <= 0 {
                self.removeAction(forKey: self.starLoopKey)
            }
        }.store(in: &bag)
    }
    
    var starfallLoop: SKAction {
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
                let moveXAction = SKAction.moveTo(x: (self.scene?.size.width ?? 2)/2, duration: 10)
                let moveYAction = SKAction.moveTo(y: (self.scene?.size.height ?? 2)/2, duration: 10)
                let rotateAction =
                SKAction.repeatForever(SKAction.rotate(byAngle: 3.1, duration: 2))
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
        
        if let (ball, fist) = checkCollision("ball", "fist") {
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            explosion?.position = ball.position
            scene?.addChild(explosion!)
            ball.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
            score += 1
        }
        
        if let (heart, ball) = checkCollision("heart", "ball") as? (SKShapeNode, SKShapeNode) {
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            player.playerStats.health -= 1
            explosion?.position = ball.position
            scene?.addChild(explosion!)
            ball.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
        }
        
        if let (letter, fist) = checkCollision("letterNode", "fist") as? (SKShapeNode, SKShapeNode) {
           print("contacted letter \(letter.userData)")
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

