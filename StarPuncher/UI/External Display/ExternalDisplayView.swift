import SwiftUI
import SpriteKit

struct ExternalDisplayView: View {
    @EnvironmentObject var viewModel: GameViewModel
    let size: CGSize
    
    var body: some View {
        ZStack {
            SpriteView(scene: viewModel.scene)
                .rotationEffect(Angle(degrees: 180))
                .ignoresSafeArea()
        }.onAppear {
            viewModel.setUp(size: size)
        }
    }
}

struct ExternalDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalDisplayView(size: CGSize.zero)
    }
}
