import SpriteKit



class MainScene: SKScene {
    var score = 0
    let scoreLabel = SKLabelNode(text: "0")
    let player: Player = RectPlayer()//PersonPlayer()
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
        spaceBackground?.position = CGPoint(x: (scene?.size.width ?? 700)/2, y: 0.0)
        spaceBackground?.particlePositionRange = CGVector(dx: scene?.size.width ?? 100, dy: 1)
        spaceBackground?.advanceSimulationTime(9.0)
        scene?.addChild(spaceBackground!)
        
        scoreLabel.fontSize = 65
        scoreLabel.fontColor = SKColor.green
        scoreLabel.position = CGPoint(x: 80, y: 80)
        scoreLabel.zRotation = 3.14159
        addChild(scoreLabel)
        
        player.setUp(scene: self)
        
        
        run(starfallLoop)
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
