import SwiftUI
import SpriteKit
import Combine

struct ContentView: View {
    @StateObject var keyTracker = KeyTracker()
    @State var bag = Set<AnyCancellable>()
    @State var flag = false
    let sensitivity = 40.0
    
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
//            z
            
            PlayerContainerView(captureSession: scene.videoViewModel.captureSession).onAppear {
                scene.videoViewModel.checkAuthorization()
                //                scene.videoViewModel.setupOutput(delgate: scene.poseViewModel)
                scene.poseViewModel.pose.sink { pose in
                    let headHeight = pose.joints[.nose]?.position.y ?? 500
                    
                    let headPosition = pose.joints[.nose]?.position ?? CGPoint.zero
                    let center = CGPoint(x: scene.frame.midX ?? 0, y: scene.frame.midY ?? 0)
                    if headPosition.x > center.x + sensitivity {
                        keyTracker.keyOn(ButtonEvent(keyNUmber: 123))
                        
                    } else {
                        keyTracker.keyOff(ButtonEvent(keyNUmber: 123))
                    }
                    
                    if headPosition.x < center.x - sensitivity {
                        keyTracker.keyOn(ButtonEvent(keyNUmber: 124))
                        
                    } else {
                        keyTracker.keyOff(ButtonEvent(keyNUmber: 124))
                    }
                    
                    if headPosition.y > center.y + sensitivity {
                        keyTracker.keyOn(ButtonEvent(keyNUmber: 125))
                        
                    } else {
                        keyTracker.keyOff(ButtonEvent(keyNUmber: 125))
                    }
                    
                    if headPosition.y < center.y - sensitivity {
                        keyTracker.keyOn(ButtonEvent(keyNUmber: 126))
                        
                    } else {
                        keyTracker.keyOff(ButtonEvent(keyNUmber: 126))
                    }
                    
                    if pose.joints[.rightWrist]?.position.y ?? 0 < headHeight {
                        keyTracker.keyOn(ButtonEvent(keyNUmber: 7))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyTracker.keyOff(ButtonEvent(keyNUmber: 7))
                        }
                    } else {
                        keyTracker.keyOff(ButtonEvent(keyNUmber: 7))
                    }
//
                    if pose.joints[.leftWrist]?.position.y ?? 0 > headHeight + 250 {
                        keyTracker.keyOn(ButtonEvent(keyNUmber: 6))
                    } else {
                        keyTracker.keyOff(ButtonEvent(keyNUmber: 6))
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
