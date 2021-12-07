import SpriteKit

class NodeProvider {
    func addRandomStars(to scene: SKScene) {
        let starSize: CGFloat = 25
        let node = SKNode()
        node.position = CGPoint(x: CGFloat.random(in: 30..<(scene.frame.maxX - 30)), y:-50)
        node.name = "ball"
        node.physicsBody = SKPhysicsBody(circleOfRadius: starSize)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody!.contactTestBitMask = 0x00000101
        node.physicsBody!.categoryBitMask = 0x00000010
        node.physicsBody!.collisionBitMask = 0x00000101
        
        let shape = SKShapeNode(path: Star(corners: 5, smoothness: 0.5).path(in: CGRect(origin: CGPoint.zero, size: CGSize(width: starSize, height: starSize))) )
        shape.fillColor = .yellow
        
        let moveAction = SKAction.moveTo(y: scene.frame.maxY + 50, duration: 10.0)
        let rotateAction =
        SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 2))
        let action = SKAction.group([rotateAction,moveAction])
        
        node.addChild(shape)
        shape.position = CGPoint(x: -starSize/2, y: -starSize/2)
        node.run(action)
        scene.addChild(node)
    }
}
