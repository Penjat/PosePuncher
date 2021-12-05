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
                HStack {
                    Spacer()
                    Text("\(viewModel.scene.score)").foregroundColor(.yellow)
                    Spacer()
                    Text("\(healthText)").foregroundColor(.blue)
                }
                Spacer()
            }.font(.title)
        }.navigationBarHidden(true)
    }
    
    var healthText: String {
        let health = viewModel.scene.player.playerStats.health
        return health > 0 ? String((0..<health).map{ _ in "♥︎"}) : "game over"
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
