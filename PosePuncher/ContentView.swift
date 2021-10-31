import SwiftUI

struct ContentView: View {
    @StateObject var videoViewModel = ContentViewModel()
    @StateObject var poseViewModel = PoseViewModel()
    let showSet = Set<Joint.Name>([.nose, .leftEye,.rightEye, .leftEar, .rightEar, .rightShoulder, .leftShoulder])
    var body: some View {
        ZStack {
//            PlayerContainerView(captureSession: videoViewModel.captureSession)
            
            if let joints = poseViewModel.pose.joints.map{ $0.value }.filter{ showSet.contains($0.name) } {
                Path { path in
                    for joint in joints {
                        switch joint.name {
                        case .nose:
                            path.move(to: joint.position)
                            path.addLine(to: CGPoint(x:joint.position.x-10, y:joint.position.y + 10))
                            path.addLine(to: CGPoint(x:joint.position.x+10, y:joint.position.y + 10))
                            path.addLine(to: joint.position)
                        case .leftEye, .rightEye:
                            path.move(to: joint.position)
                            path.addLine(to: CGPoint(x:joint.position.x-10, y:joint.position.y))
                            path.addLine(to: CGPoint(x:joint.position.x-10, y:joint.position.y-10))
                            path.addLine(to: CGPoint(x:joint.position.x, y:joint.position.y-10))
                            path.addLine(to: joint.position)
                        default:
                            break
                        }
                    }
                }.stroke(Color.red, lineWidth: 2)
            }
        }.onAppear {
            videoViewModel.checkAuthorization()
            videoViewModel.setupOutput(delgate: poseViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
