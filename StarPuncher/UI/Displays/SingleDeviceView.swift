import SwiftUI
import SpriteKit

struct SingleDeviceView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        GameView().onAppear {
            viewModel.setUpScene(size: UIScreen.main.bounds.size)
        }
    }
}

struct SingleDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDeviceView()
    }
}
