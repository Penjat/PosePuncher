import SwiftUI
import SpriteKit
import Combine

struct ContentView: View {
    @StateObject var keyTracker = KeyTracker()
    @State var bag = Set<AnyCancellable>()
    @State var flag = false
    let rightArrowKeyCode: UInt16 = 125
    
    
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
                scene.poseViewModel.pose.sink { pose in
                    let headHeight = pose.joints[.nose]?.position.y ?? 500
                    if pose.joints[.rightWrist]?.position.y ?? 0 < headHeight {
                        keyTracker.keyOn(ButtonEvent(keyNUmber: 126))
                    } else {
                        keyTracker.keyOff(ButtonEvent(keyNUmber: 126))
                    }
                    
                    if pose.joints[.rightWrist]?.position.y ?? 0 > headHeight + 250 {
                        keyTracker.keyOn(ButtonEvent(keyNUmber: 125))
                    } else {
                        keyTracker.keyOff(ButtonEvent(keyNUmber: 125))
                    }
                }.store(in: &bag)
                
            }.opacity(0.4)
            
            HStack {
                ForEach(Array(keyTracker.heldKeys), id: \.self) { heldKey in
                    Text("\(heldKey.keyNUmber)")
                }
            }
            
            
        }.frame(width: 1280, height: 720).ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
