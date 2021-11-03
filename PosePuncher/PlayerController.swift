import SpriteKit
import Combine

class PlayerController {
    let playerBody: SKNode
    var bag = Set<AnyCancellable>()
    
    var rightEye: SKShapeNode?
    var leftEye: SKShapeNode?
    
    var leftWrist: SKShapeNode?
    var rightWrist: SKShapeNode?
    
    var leftElbow: SKShapeNode?
    var rightElbow: SKShapeNode?
    
    var leftShoulder: SKShapeNode?
    var rightShoulder: SKShapeNode?
    
    init() {
        playerBody = SKNode()
        
        rightEye = SKShapeNode(circleOfRadius: 10 )

        rightEye?.fillColor = .blue
//        rightEye?.lineWidth = 10
        rightEye?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        rightEye?.physicsBody?.isDynamic = true
        rightEye?.physicsBody?.affectedByGravity = false
        rightEye?.name = "rightEye"
        rightEye?.physicsBody!.contactTestBitMask = 1

        playerBody.addChild(rightEye!)
        
        leftEye = SKShapeNode(circleOfRadius: 10 )
        
        leftEye?.fillColor = .blue
//        leftEye?.lineWidth = 10
        leftEye?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        leftEye?.physicsBody?.isDynamic = true
        leftEye?.physicsBody?.affectedByGravity = false
        leftEye?.name = "leftEye"
        leftEye?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftEye!)
        
        
        leftWrist = SKShapeNode(circleOfRadius: 20 )
        leftWrist?.fillColor = .red
//        leftEye?.lineWidth = 10
        leftWrist?.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        leftWrist?.physicsBody?.isDynamic = true
        leftWrist?.physicsBody?.affectedByGravity = false
        leftWrist?.name = "fist"
        leftWrist?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftWrist!)
        
        rightWrist = SKShapeNode(circleOfRadius: 20 )
        rightWrist?.fillColor = .red
//        leftEye?.lineWidth = 10
        rightWrist?.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        rightWrist?.physicsBody?.isDynamic = true
        rightWrist?.physicsBody?.affectedByGravity = false
        rightWrist?.name = "fist"
        rightWrist?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(rightWrist!)
        
        leftElbow = SKShapeNode(circleOfRadius: 10 )
        leftElbow?.fillColor = .blue
//        leftEye?.lineWidth = 10
        leftElbow?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        leftElbow?.physicsBody?.isDynamic = true
        leftElbow?.physicsBody?.affectedByGravity = false
        leftElbow?.name = "leftElbow"
        leftElbow?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftElbow!)
        
        rightElbow = SKShapeNode(circleOfRadius: 10 )
        rightElbow?.fillColor = .blue
//        leftEye?.lineWidth = 10
        rightElbow?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        rightElbow?.physicsBody?.isDynamic = true
        rightElbow?.physicsBody?.affectedByGravity = false
        rightElbow?.name = "rightElbow"
        rightElbow?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(rightElbow!)
        
        leftShoulder = SKShapeNode(circleOfRadius: 10 )
        leftShoulder?.fillColor = .blue
//        leftEye?.lineWidth = 10
        leftShoulder?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        leftShoulder?.physicsBody?.isDynamic = true
        leftShoulder?.physicsBody?.affectedByGravity = false
        leftShoulder?.name = "leftShoulder"
        leftShoulder?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftShoulder!)
        
        rightShoulder = SKShapeNode(circleOfRadius: 10 )
        rightShoulder?.fillColor = .blue
//        leftEye?.lineWidth = 10
        rightShoulder?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        rightShoulder?.physicsBody?.isDynamic = true
        rightShoulder?.physicsBody?.affectedByGravity = false
        rightShoulder?.name = "rightShoulder"
        rightShoulder?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(rightShoulder!)
        
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
                case .leftWrist:
                    self.leftWrist?.position = joint.position
                case .rightWrist:
                    self.rightWrist?.position = joint.position
                case .leftShoulder:
                    self.leftShoulder?.position = joint.position
                case .rightShoulder:
                    self.rightShoulder?.position = joint.position
                case .leftElbow:
                    self.leftElbow?.position = joint.position
                case .rightElbow:
                    self.rightElbow?.position = joint.position
                default:
                    break
                }
            }
        }.store(in: &bag)
    }
}
