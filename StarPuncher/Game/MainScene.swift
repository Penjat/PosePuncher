import SpriteKit
import Combine


class MainScene: SKScene {
    var score = 0
    let player: Player = RectPlayer()//PersonPlayer()
    var bag = Set<AnyCancellable>()
    let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
    var starLoop: SKAction?
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        spaceBackground?.position = CGPoint(x: (scene?.size.width ?? 700)/2, y: 0.0)
        spaceBackground?.particlePositionRange = CGVector(dx: scene?.size.width ?? 100, dy: 1)
        spaceBackground?.advanceSimulationTime(9.0)
        scene?.addChild(spaceBackground!)
        
        player.setUp(scene: self)
        
        starLoop = starcircleLoop
        
        player.playerStats.$health.sink { health in
            self.scene?.isPaused = (health <= 0)
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
        
        if let (heart, ball) = checkCollision("heart", "ball") {
            let explosion = SKEmitterNode(fileNamed: "Explosion")
            player.playerStats.health -= 1
            explosion?.position = ball.position
            scene?.addChild(explosion!)
            ball.removeFromParent()
            self.run(SKAction.wait(forDuration: 2), completion: { explosion?.removeFromParent() })
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

