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
                Spacer()
                Text("\(viewModel.scene.score)")
                Spacer()
                Text("\(healthText)")
            }
        }
    }
    
    var healthText: String {
        String((0..<viewModel.scene.player.playerStats.health).map{ _ in "♥︎"})
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
