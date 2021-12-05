import SwiftUI
import SpriteKit

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        ZStack {
            SpriteView(scene: viewModel.scene)
                .rotationEffect(Angle(degrees: 180))
                .ignoresSafeArea()
            VStack {
                Text("\(viewModel.scene.player.playerStats.health)").foregroundColor(.blue)
            }
        }.onAppear {
            viewModel.setUpCamera()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
