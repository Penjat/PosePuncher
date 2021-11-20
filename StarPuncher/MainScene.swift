import SpriteKit

class MainScene: SKScene, SKPhysicsContactDelegate {
    var playerNose: SKShapeNode?
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground")
        spaceBackground?.position = CGPoint(x: 700, y: 0.0)
        scene?.addChild(spaceBackground!)
        
        playerNose = SKShapeNode(circleOfRadius: 10)
        playerNose?.fillColor = .blue
        if let nose = playerNose {
            scene?.addChild(nose)
        }
        
//
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
    }
    
    func drawPlayer(pose: Pose) {
        guard pose.confidence > 0.05 else {
            return
        }
        playerNose?.position = pose.joints.first(where: { $0.key == .nose})?.value.position ?? CGPoint()
    }
}
