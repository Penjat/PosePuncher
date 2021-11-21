import SwiftUI
import SpriteKit

struct ExternalDisplayView: View {
    let size: CGSize
    @StateObject var viewModel = GameViewModel()
    var body: some View {
        ZStack {
            SpriteView(scene: viewModel.scene)
                .rotationEffect(Angle(degrees: 180))
                .ignoresSafeArea()
//            CameraView(session: viewModel.videoService.videoCapture.captureSession).opacity(0.2).aspectRatio( contentMode: .fit)
        }.onAppear {
            print("number of screens = \(UIScreen.screens.count)")
            viewModel.setUp(size: size)
        }
    }
}

struct ExternalDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalDisplayView(size: CGSize.zero)
    }
}
