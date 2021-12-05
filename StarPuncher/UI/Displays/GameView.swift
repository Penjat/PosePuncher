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
                    Text("\(healthText)").foregroundColor(.blue)
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setUpCamera()
        }
    }
    
    var healthText: String {
        let health = viewModel.scene.player.playerStats.health
        guard health > 0 else {
            return "game over"
        }
        return String((0..<health).map { _ in "♥︎" })
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
