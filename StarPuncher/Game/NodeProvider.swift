import SpriteKit

class NodeProvider {
    func addRandomStars(to scene: SKScene) {
        let shape = SKShapeNode(path: Star(corners: 5, smoothness: 0.5).path(in: CGRect(origin: CGPoint.zero, size: CGSize(width: 25, height: 25))) )
        shape.position = CGPoint(x: CGFloat.random(in: 30..<(scene.frame.maxX - 30)), y:-50)
        shape.fillColor = .yellow
        shape.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        shape.physicsBody?.isDynamic = true
        shape.physicsBody?.affectedByGravity = false
        shape.name = "ball"
        shape.physicsBody!.contactTestBitMask = 1
        let moveAction = SKAction.moveTo(y: scene.frame.maxY + 50, duration: 10.0)
        let rotateAction =
        SKAction.repeatForever(SKAction.rotate(byAngle: 3.1, duration: 2))
        let action = SKAction.group([rotateAction,moveAction])
        shape.run(action)
        scene.addChild(shape)
    }
}
