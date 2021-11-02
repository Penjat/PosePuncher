//import SwiftUI
//import SpriteKit
//
//struct CharacterView: View {
//    struct JointSegment {
//        let jointA: Joint.Name
//        let jointB: Joint.Name
//    }
//    
//    
//    
//    
//    let jointSegments = [
//        // The connected joints that are on the left side of the body.
//        //        JointSegment(jointA: .leftHip, jointB: .leftShoulder),
//        JointSegment(jointA: .leftShoulder, jointB: .leftElbow),
//        JointSegment(jointA: .leftElbow, jointB: .leftWrist),
//        //        JointSegment(jointA: .leftHip, jointB: .leftKnee),
//        //        JointSegment(jointA: .leftKnee, jointB: .leftAnkle),
//        //        // The connected joints that are on the right side of the body.
//        //        JointSegment(jointA: .rightHip, jointB: .rightShoulder),
//        JointSegment(jointA: .rightShoulder, jointB: .rightElbow),
//        JointSegment(jointA: .rightElbow, jointB: .rightWrist),
//        //        JointSegment(jointA: .rightHip, jointB: .rightKnee),
//        //        JointSegment(jointA: .rightKnee, jointB: .rightAnkle),
//        // The connected joints that cross over the body.
//        JointSegment(jointA: .leftShoulder, jointB: .rightShoulder),
//        //        JointSegment(jointA: .leftHip, jointB: .rightHip)
//    ]
//    
//    @StateObject var videoViewModel = ContentViewModel()
//    @StateObject var poseViewModel = PoseViewModel()
//    let showSet = Set<Joint.Name>([.nose, .leftEye,.rightEye, .leftEar, .rightEar, .rightShoulder, .leftShoulder, .rightWrist, .leftWrist, .rightElbow, .leftElbow])
//    var body: some View {
//        ZStack {
//            PlayerContainerView(captureSession: videoViewModel.captureSession)
//            
//            player
//            buttons
//            
//        }.frame(width: 1280, height: 720)
//            .onAppear {
//                videoViewModel.checkAuthorization()
//                videoViewModel.setupOutput(delgate: poseViewModel)
//            }
//    }
//    
//    var player: some View {
//        ZStack {
//            if let joints = poseViewModel.pose.joints.map{ $0.value }.filter{ showSet.contains($0.name) && $0.isValid} {
//                ForEach(jointSegments, id: \.jointA) { segment in
//                    let jointA = poseViewModel.pose[segment.jointA]
//                    let jointB = poseViewModel.pose[segment.jointB]
//                    
//                    Path { path in
//                        path.move(to: jointA.position)
//                        path.addLine(to: jointB.position)
//                    }.stroke(Color.blue, lineWidth: 4)
//                }
//                
//                ForEach(joints, id: \.name) { joint in
//                    switch joint.name {
//                        //                    case .nose:
//                        //                        Path { path in
//                        //                            drawSquare(path: &path, point: joint.position, width: 10)
//                        //                            drawSquare(path: &path, point: joint.position, width: 20)
//                        //                            drawSquare(path: &path, point: joint.position, width: 30)
//                        //                            drawSquare(path: &path, point: joint.position, width: 40)
//                        //                            drawSquare(path: &path, point: joint.position, width: 200)
//                        //
//                        //                        }.stroke(Color.red, lineWidth: 2)
//                        
//                        
//                    case .leftEye, .rightEye:
//                        Path { path in
//                            drawSquare(path: &path, point: joint.position, width: 10)
//                            drawSquare(path: &path, point: joint.position, width: 20)
//                            drawSquare(path: &path, point: joint.position, width: 30)
//                            drawSquare(path: &path, point: joint.position, width: 40)
//                            drawSquare(path: &path, point: joint.position, width: 50)
//                            drawSquare(path: &path, point: joint.position, width: 60)
//                        }.stroke(Color.blue, lineWidth: 4)
//                        
//                    case .leftShoulder, .rightShoulder, .leftElbow, .rightElbow:
//                        Path { path in
//                            path.move(to: joint.position)
//                            path.addLine(to: CGPoint(x:joint.position.x-20, y:joint.position.y))
//                            path.addLine(to: CGPoint(x:joint.position.x-20, y:joint.position.y-20))
//                            path.addLine(to: CGPoint(x:joint.position.x, y:joint.position.y-20))
//                            path.addLine(to: joint.position)
//                        }.stroke(Color.green, lineWidth: 4)
//                        
//                    case .leftWrist, .rightWrist:
//                        Path { path in
//                            drawSquare(path: &path, point: joint.position, width: 40)
//                            
//                        }.stroke(Color.green, lineWidth: 4)
//                    default:
//                        EmptyView()
//                    }
//                }.frame(width: 1280, height: 720)
//            }
//        }
//    }
//    
//    var buttons: some View {
//        Path { path in
//            path.move(to: CGPoint(x: 20, y: 20))
//            path.addLine(to: CGPoint(x:60, y: 20))
//            path.addLine(to: CGPoint(x:60, y: 60))
//            path.addLine(to: CGPoint(x:20, y:60))
//            path.addLine(to: CGPoint(x: 20, y: 20))
//        }.stroke(Color.green, lineWidth: 4)
//    }
//    
//    
//    func drawSquare(path: inout Path, point: CGPoint, width: CGFloat) {
//        let halfWidth = width/2
//        path.move(to: CGPoint(x:point.x-halfWidth, y:point.y - halfWidth))
//        path.addLine(to: CGPoint(x:point.x-halfWidth, y:point.y + halfWidth))
//        path.addLine(to: CGPoint(x:point.x+halfWidth, y:point.y + halfWidth))
//        path.addLine(to: CGPoint(x:point.x+halfWidth, y:point.y - halfWidth))
//        path.addLine(to: CGPoint(x:point.x-halfWidth, y:point.y - halfWidth))
//    }
//}
//
//struct CharacterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterView()
//    }
//}
