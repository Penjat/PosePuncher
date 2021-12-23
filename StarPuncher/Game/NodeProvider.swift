import SpriteKit
import Combine

class NodeProvider: ObservableObject {
    lazy var generators = [
        NodeGenerator(wav: {(triangleWave($0)+1)/2 }),
        NodeGenerator(wav: {1 - (triangleWave($0)+1)/2 }),
    ]
    let changeWaveRate = 16
    let changeColorRate = 128.0
    let fallTime: CGFloat = 7
    @Published var counter = 0
    let rate = Double.pi/16
    var wavForm = triangleWave
    var bag = Set<AnyCancellable>()
    
    init() {
//        $counter.sink { value in
//            if value%self.changeWaveRate == 0 {
//                self.wavForm = { self.randomWav($0*Double.random(in: 0.3...5))/2 + self.randomWav($0*Double.random(in: 0.3...5))/4}
//            }
//        }.store(in: &bag)
    }
    
    func addRandomStars(to scene: SKScene) {
        generators.forEach { generator in
            fallingStar(at: CGPoint(x: generator.wav(Double(counter)*rate)*(scene.frame.maxX - 50)+25.0, y: -50.0), scene: scene)
        }
        counter += 1
    }
    
    func fallingStar(at point: CGPoint, scene: SKScene) {
        let node = starNode(Double(counter)*Double.pi/changeColorRate)
        node.position = point
        let moveAction = SKAction.moveTo(y: scene.frame.maxY + 50, duration: fallTime)
        let rotateAction =
        SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 2))
        let action = SKAction.group([rotateAction,moveAction])
    
        node.run(action)
        scene.addChild(node)
    }
    
    func wavScene(_ scene: SKScene, index: Double) -> CGPoint {
        let x = wavForm(index)
        return CGPoint(x: x*(scene.frame.maxX - 50) + 25, y:-50)
    }
    
    func randomTopPos(_ scene: SKScene) -> CGPoint {
        let x = CGFloat.random(in: 1..<((scene.frame.maxX - 50)/50))
        return CGPoint(x: x*50, y:-50)
    }
    
    var randomWav: (Double) -> Double {
        [sin, triangleWave, sawWave, {(squareWave($0*7)+0.25)/2 }, noise].randomElement() ?? sin
    }
    
    func starNode(_ theta: Double) -> SKNode {
        let starSize: CGFloat = 25
        let node = SKNode()
        
        node.name = "ball"
        node.physicsBody = SKPhysicsBody(circleOfRadius: starSize)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody!.contactTestBitMask = 0x00000101
        node.physicsBody!.categoryBitMask = 0x00000010
        node.physicsBody!.collisionBitMask = 0x00000101
        
        let shape = SKShapeNode(path: Star(corners: 5, smoothness: 0.5).path(in: CGRect(origin: CGPoint.zero, size: CGSize(width: starSize, height: starSize))))
        shape.name = "shape"
        let color = UIColor(calcRGB(theta, redWav: { (sin($0)+1)/2 }, blueWav: { (sin($0+Double.pi*2/3*2)+1)/2 }, greenWav: { (sin($0+Double.pi*2/3)+1)/2 } ).3)
        shape.fillColor = color
        print(color)
        shape.strokeColor = .clear
        node.addChild(shape)
        shape.position = CGPoint(x: -starSize/2, y: -starSize/2)
        
        return node
    }
}
