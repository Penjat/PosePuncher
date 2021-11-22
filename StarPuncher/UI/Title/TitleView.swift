import SwiftUI

struct TitleView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        ZStack {
            CameraView(session: viewModel.videoService.videoCapture.captureSession)
                .opacity(0.5).aspectRatio( contentMode: .fit)
            
            Text("\(viewModel.pose.confidence)")
        }.onAppear {
            print("title appeared")
            viewModel.setUpCamera()
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
