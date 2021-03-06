import SpriteKit

let aplhabet = "abcdefghijklmnopqrstuvwxyz"

class TextInputPresenter {
    
    var node: SKNode = {
        let radius: CGFloat = 180.0
        let bodyNode = SKNode()
        aplhabet.uppercased().enumerated().forEach { (index, letter) in
            
            let theta: CGFloat = (CGFloat(index)/CGFloat(aplhabet.count)) * -2 * CGFloat.pi
            
            let red: CGFloat = (sin(-theta - (0 * 2*CGFloat.pi/3.0)) + 1)/2
            let blue: CGFloat = (sin(-theta - ( 2*2*CGFloat.pi/3.0)) + 1)/2
            let green: CGFloat = (sin(-theta - ( 1*2*CGFloat.pi/3.0)) + 1)/2
            
            var color = UIColor(red: red, green: green, blue: blue, alpha: 1)
            
            let keyNode = letterNode(String(letter), color: color)
            keyNode.position = CGPoint(x: cos(theta)*radius , y: sin(theta)*radius)
            bodyNode.addChild(keyNode)
        }
        
        return bodyNode
    }()
    
    static func letterNode(_ letter: String, color: UIColor) -> SKLabelNode {
        let newColor = color.copy() as! UIColor
        let letterNode = SKLabelNode(text: letter)
        letterNode.zRotation = 3.14159
        let circle = SKShapeNode.init(circleOfRadius: 20)
        circle.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        circle.physicsBody?.isDynamic = true
        circle.physicsBody?.affectedByGravity = false
        circle.name = "letterNode"
        circle.userData = ["letter": letter]
        circle.physicsBody!.categoryBitMask = 0x00000001
        circle.physicsBody!.contactTestBitMask = 0x00000002
        circle.physicsBody!.collisionBitMask = 0x00000002
        letterNode.fontColor = newColor
        circle.lineWidth = 2
        circle.strokeColor = newColor
        circle.zPosition = -5
        letterNode.fontName = "AvenirNext-Bold"
        
        letterNode.addChild(circle)
        circle.position = CGPoint(x: 0 ,y: 11)
        
        return letterNode
    }
}
