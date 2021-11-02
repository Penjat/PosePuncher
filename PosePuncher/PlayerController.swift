import SpriteKit
import Combine

class PlayerController {
    let playerBody: SKNode
    var bag = Set<AnyCancellable>()
    
    var rightEye: SKShapeNode?
    var leftEye: SKShapeNode?
    init() {
        playerBody = SKNode()
        
        rightEye = SKShapeNode(circleOfRadius: 10 )

        rightEye?.fillColor = .blue
//        rightEye?.lineWidth = 10
        rightEye?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        rightEye?.physicsBody?.isDynamic = false
        rightEye?.physicsBody?.affectedByGravity = false
        rightEye?.name = "ball"
        rightEye?.physicsBody!.contactTestBitMask = 1

        playerBody.addChild(rightEye!)
        
        leftEye = SKShapeNode(circleOfRadius: 10 )
        
        leftEye?.fillColor = .blue
//        leftEye?.lineWidth = 10
        leftEye?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        leftEye?.physicsBody?.isDynamic = false
        leftEye?.physicsBody?.affectedByGravity = false
        leftEye?.name = "ball"
        leftEye?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftEye!)
        
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
                    break
                default:
                    break
                }
            }
        }.store(in: &bag)
    }
}
