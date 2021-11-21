import SwiftUI

struct TitleView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        CameraView(session: viewModel.videoService.videoCapture.captureSession).opacity(0.2).aspectRatio( contentMode: .fit)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
