import SwiftUI

struct ContentView: View {
    @StateObject var videoViewModel = ContentViewModel()
    @StateObject var poseViewModel = PoseViewModel()
    let showSet = Set<Joint.Name>([.leftEye,.rightEye,.rightElbow, .leftElbow,.rightWrist,.leftWrist, .leftEar, .rightEar, .rightShoulder, .leftShoulder])
    var body: some View {
        ZStack {
            PlayerContainerView(captureSession: videoViewModel.captureSession).onAppear {
                videoViewModel.checkAuthorization()
                videoViewModel.setupOutput(delgate: poseViewModel)
            }
            
            if let joints = poseViewModel.pose.joints.map{ $0.value }.filter{ showSet.contains($0.name) } {
                Path { path in
                    for joint in joints {
                        path.move(to: joint.position)
                        path.addLine(to: CGPoint(x:joint.position.x, y:joint.position.y - 10))
                    }
                }.stroke(Color.red, lineWidth: 10)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
