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
    
    var rightLowerArm = SKShapeNode()
    var leftLowerArm = SKShapeNode()
    var rightUpperArm = SKShapeNode()
    var leftUpperArm = SKShapeNode()
    
    var shoulderLine = SKShapeNode()
    
    init() {
        playerBody = SKNode()
        
        rightEye = SKShapeNode(circleOfRadius: 10 )

        rightEye?.fillColor = .blue
        rightEye?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        rightEye?.physicsBody?.isDynamic = true
        rightEye?.physicsBody?.affectedByGravity = false
        rightEye?.name = "rightEye"
        rightEye?.physicsBody!.contactTestBitMask = 1

        playerBody.addChild(rightEye!)
        
        leftEye = SKShapeNode(circleOfRadius: 10 )
        
        leftEye?.fillColor = .blue
        leftEye?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        leftEye?.physicsBody?.isDynamic = true
        leftEye?.physicsBody?.affectedByGravity = false
        leftEye?.name = "leftEye"
        leftEye?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftEye!)
        
        
        leftWrist = SKShapeNode(circleOfRadius: 40 )
        leftWrist?.fillColor = .red
        leftWrist?.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        leftWrist?.physicsBody?.isDynamic = true
        leftWrist?.physicsBody?.affectedByGravity = false
        leftWrist?.name = "fist"
        leftWrist?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftWrist!)
        
        rightWrist = SKShapeNode(circleOfRadius: 40 )
        rightWrist?.fillColor = .red
        rightWrist?.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        rightWrist?.physicsBody?.isDynamic = true
        rightWrist?.physicsBody?.affectedByGravity = false
        rightWrist?.name = "fist"
        rightWrist?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(rightWrist!)
        
        leftElbow = SKShapeNode(circleOfRadius: 10 )
        leftElbow?.fillColor = .blue
        leftElbow?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        leftElbow?.physicsBody?.isDynamic = true
        leftElbow?.physicsBody?.affectedByGravity = false
        leftElbow?.name = "leftElbow"
        leftElbow?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftElbow!)
        
        rightElbow = SKShapeNode(circleOfRadius: 10 )
        rightElbow?.fillColor = .blue
        rightElbow?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        rightElbow?.physicsBody?.isDynamic = true
        rightElbow?.physicsBody?.affectedByGravity = false
        rightElbow?.name = "rightElbow"
        rightElbow?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(rightElbow!)
        
        leftShoulder = SKShapeNode(circleOfRadius: 10 )
        leftShoulder?.fillColor = .blue
        leftShoulder?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        leftShoulder?.physicsBody?.isDynamic = true
        leftShoulder?.physicsBody?.affectedByGravity = false
        leftShoulder?.name = "leftShoulder"
        leftShoulder?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(leftShoulder!)
        
        rightShoulder = SKShapeNode(circleOfRadius: 10 )
        rightShoulder?.fillColor = .blue
        rightShoulder?.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        rightShoulder?.physicsBody?.isDynamic = true
        rightShoulder?.physicsBody?.affectedByGravity = false
        rightShoulder?.name = "rightShoulder"
        rightShoulder?.physicsBody!.contactTestBitMask = 1
        
        playerBody.addChild(rightShoulder!)
        
        
        rightLowerArm.lineWidth = 10
        rightLowerArm.strokeColor = SKColor.green
        playerBody.addChild(rightLowerArm)
        
        leftLowerArm.lineWidth = 10
        leftLowerArm.strokeColor = SKColor.green
        playerBody.addChild(leftLowerArm)
        
        rightUpperArm.lineWidth = 10
        rightUpperArm.strokeColor = SKColor.green
        playerBody.addChild(rightUpperArm)
        
        leftUpperArm.lineWidth = 10
        leftUpperArm.strokeColor = SKColor.green
        playerBody.addChild(leftUpperArm)
        
        shoulderLine.lineWidth = 10
        shoulderLine.strokeColor = SKColor.green
        playerBody.addChild(shoulderLine)
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
            
            let rightUpperArmPath = CGMutablePath()
            rightUpperArmPath.move(to: self.rightShoulder?.position ?? CGPoint())
            rightUpperArmPath.addLine(to: self.rightElbow?.position ?? CGPoint())
            self.rightUpperArm.path = rightUpperArmPath
            
            let leftUpperArmPath = CGMutablePath()
            leftUpperArmPath.move(to: self.leftShoulder?.position ?? CGPoint())
            leftUpperArmPath.addLine(to: self.leftElbow?.position ?? CGPoint())
            self.leftUpperArm.path = leftUpperArmPath
            
            let rightLowerArmPath = CGMutablePath()
            rightLowerArmPath.move(to: self.rightWrist?.position ?? CGPoint())
            rightLowerArmPath.addLine(to: self.rightElbow?.position ?? CGPoint())
            self.rightLowerArm.path = rightLowerArmPath
            
            let leftLowerArmPath = CGMutablePath()
            leftLowerArmPath.move(to: self.leftWrist?.position ?? CGPoint())
            leftLowerArmPath.addLine(to: self.leftElbow?.position ?? CGPoint())
            self.leftLowerArm.path = leftLowerArmPath
            
            let shoulderLinePath = CGMutablePath()
            shoulderLinePath.move(to: self.leftWrist?.position ?? CGPoint())
            shoulderLinePath.addLine(to: self.leftElbow?.position ?? CGPoint())
            self.leftLowerArm.path = shoulderLinePath
            
        }.store(in: &bag)
    }
}
