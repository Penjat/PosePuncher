import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var viewModel = GameViewModel()
    var body: some View {
        ZStack {
            SpriteView(scene: viewModel.scene)
                .rotationEffect(Angle(degrees: 180))
//                .frame(width: 1280, height: 720)
                .ignoresSafeArea()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
