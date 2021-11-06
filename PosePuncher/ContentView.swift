import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene = {
        let scene = GameScene()
        scene.size = CGSize(width: 1280, height: 720)
//        scene.scaleMode = .fill
        scene.scaleMode = .aspectFit
        scene.setUp()
        return scene
    }()
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
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
