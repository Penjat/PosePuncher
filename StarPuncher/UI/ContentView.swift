import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var viewModel = GameViewModel()
    var body: some View {
        ZStack {
            SpriteView(scene: viewModel.scene)
                .rotationEffect(Angle(degrees: 180))
                .ignoresSafeArea()
            CameraView(session: viewModel.videoService.videoCapture.captureSession).opacity(0.2).aspectRatio( contentMode: .fit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
