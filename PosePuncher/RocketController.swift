import SpriteKit
import Combine

class RocketController {
    let playerBody: SKNode
    var bag = Set<AnyCancellable>()
    
    var rightEye: SKShapeNode?
    var leftEye: SKShapeNode?
    var head: SKShapeNode?
    
    init(particleTarget: SKNode) {
        playerBody = SKNode()
        
        rightEye = SKShapeNode(circleOfRadius: 10 )

//        rightEye?.fillColor = .blue
        rightEye?.strokeColor = .white
        rightEye?.lineWidth = 2
//        rightEye?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
//        rightEye?.physicsBody?.isDynamic = true
        rightEye?.physicsBody?.affectedByGravity = false
        rightEye?.name = "rightEye"
//        rightEye?.physicsBody!.contactTestBitMask = 1

        playerBody.addChild(rightEye!)
        
        leftEye = SKShapeNode(circleOfRadius: 10 )
        
//        leftEye?.fillColor = .blue
        leftEye?.strokeColor = .white
        leftEye?.lineWidth = 2
//        leftEye?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
//        leftEye?.physicsBody?.isDynamic = true
        leftEye?.physicsBody?.affectedByGravity = false
        leftEye?.name = "leftEye"
//        leftEye?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftEye!)
        
        head = SKShapeNode(rect: CGRect(x: -50, y: -50, width: 100, height: 100) )
        
        head?.strokeColor = .white
        head?.lineWidth = 2
        head?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        head?.physicsBody?.isDynamic = false
        head?.physicsBody?.affectedByGravity = false
        head?.name = "fist"
        head?.physicsBody!.contactTestBitMask = 1
        playerBody.addChild(head!)
        
//        let trail = SKEmitterNode(fileNamed: "RocketTrail")!
//        head?.addChild(trail)
//        trail.position = CGPoint(x: 0, y: 50)
//        trail.targetNode = particleTarget
        
    }
    
    func setUpSink(posePublisher: AnyPublisher<Pose, Never>) {
        posePublisher.sink { pose in
            let joints = pose.joints.map{ $0.value }.filter{ $0.isValid}
            joints.forEach { joint in
                switch joint.name {
                case .rightEye:
                    self.rightEye?.position = joint.position
                case .leftEye:
                    self.leftEye?.position = joint.position
                case .nose:
                    self.head?.position = CGPoint(x: joint.position.x, y: joint.position.y)
                default:
                    break
                }
            }
//            self.head?.position = CGPoint(x: (self.rightEye!.position.x + self.leftEye!.position.x)/2.0, y: (self.rightEye!.position.y + self.leftEye!.position.y)/2.0)
        }.store(in: &bag)
    }
}
