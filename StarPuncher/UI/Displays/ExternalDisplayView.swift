import SwiftUI
import SpriteKit

struct ExternalDisplayView: View {
    @EnvironmentObject var viewModel: GameViewModel
    let size: CGSize
    
    var body: some View {
        GameView().onAppear {
            viewModel.setUpScene(size: size)
        }
    }
}

struct ExternalDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalDisplayView(size: CGSize.zero)
    }
}
