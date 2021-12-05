import SwiftUI
import SpriteKit

struct SingleDeviceView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        ZStack {
            SpriteView(scene: viewModel.scene)
                .rotationEffect(Angle(degrees: 180))
                .ignoresSafeArea()
        }.onAppear {
            viewModel.setUpCamera()
            viewModel.setUpScene(size: UIScreen.main.bounds.size)
        }
    }
}

struct SingleDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDeviceView()
    }
}
