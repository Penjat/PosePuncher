import SwiftUI
import SpriteKit
import Combine

struct ContentView: View {
    @State var cancellable: AnyCancellable?
    @State var flag = false
    let rightArrowKeyCode: UInt16 = 125
    //    var scene: SKScene = {
    //        let scene = GameScene()
    //        scene.size = CGSize(width: 1280, height: 720)
    ////        scene.scaleMode = .fill
    //        scene.scaleMode = .aspectFit
    //        scene.setUp()
    //        return scene
    //    }()
    
    var scene: GameScene = {
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

            PlayerContainerView(captureSession: scene.videoViewModel.captureSession).onAppear {
                scene.videoViewModel.checkAuthorization()
//                scene.videoViewModel.setupOutput(delgate: scene.poseViewModel)
                
            }.opacity(0.4)
        }.frame(width: 1280, height: 720).ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
