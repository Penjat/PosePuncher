import SpriteKit

class NodeProvider {
    let fallTime: CGFloat = 7
    var counter = 0.0
    let rate = Double.pi/4
    func addRandomStars(to scene: SKScene) {
        
        fallingStar(at: wavScene(scene, index: counter), scene: scene)
        counter += rate
    }
    
    func fallingStar(at point: CGPoint, scene: SKScene) {
        let node = starNode
        node.position = point
        let moveAction = SKAction.moveTo(y: scene.frame.maxY + 50, duration: fallTime)
        let rotateAction =
        SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 2))
        let action = SKAction.group([rotateAction,moveAction])
    
        node.run(action)
        scene.addChild(node)
    }
    
    func wavScene(_ scene: SKScene, index: Double) -> CGPoint {
        let x = (sin(index)+1)/2
        return CGPoint(x: x*(scene.frame.maxX - 50) + 25, y:-50)
    }
    
    func randomTopPos(_ scene: SKScene) -> CGPoint {
        let x = CGFloat.random(in: 1..<((scene.frame.maxX - 50)/50))
        return CGPoint(x: x*50, y:-50)
    }
    
    var starNode: SKNode {
        let starSize: CGFloat = 25
        let node = SKNode()
        
        node.name = "ball"
        node.physicsBody = SKPhysicsBody(circleOfRadius: starSize)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody!.contactTestBitMask = 0x00000101
        node.physicsBody!.categoryBitMask = 0x00000010
        node.physicsBody!.collisionBitMask = 0x00000101
        
        let shape = SKShapeNode(path: Star(corners: 5, smoothness: 0.5).path(in: CGRect(origin: CGPoint.zero, size: CGSize(width: starSize, height: starSize))) )
        shape.fillColor = .yellow
        
        node.addChild(shape)
        shape.position = CGPoint(x: -starSize/2, y: -starSize/2)
        
        return node
    }
}
