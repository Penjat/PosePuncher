import SwiftUI

struct ContentView: View {
    @StateObject var videoViewModel = ContentViewModel()
    @StateObject var poseViewModel = PoseViewModel()
    init() {
        videoViewModel.checkAuthorization()
    }
    
    var body: some View {
        PlayerContainerView(captureSession: videoViewModel.captureSession)
            //.clipShape(Circle())
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
