import SwiftUI

struct ContentView: View {
    @StateObject var videoViewModel = ContentViewModel()
    @StateObject var poseViewModel = PoseViewModel()
 
    var body: some View {
        PlayerContainerView(captureSession: videoViewModel.captureSession).onAppear {
            videoViewModel.checkAuthorization()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
