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
    
    var body: some View {
        //        ZStack {
        //            SpriteView(scene: scene)
        //                .rotationEffect(Angle(degrees: 180))
        ////                .frame(width: 1280, height: 720)
        //                .ignoresSafeArea()
        //        }
        
        Text("heelo").onAppear {
            cancellable = Timer.publish(every: 2.0, on: .main, in: .default)
                .autoconnect()
                .receive(on: DispatchQueue.main).sink(receiveValue: { _ in
                    print("ping")
                    
                    
                    
                    print("key down")
                    let src = CGEventSource(stateID: .privateState)
                    let keyDownEvent = CGEvent(keyboardEventSource: src, virtualKey: rightArrowKeyCode, keyDown: true)
//                    keyDownEvent?.flags = CGEventFlags.maskCommand
                    
                    keyDownEvent?.setSource(src)
                    keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        print("key up")
                        
                        let keyUpEvent = CGEvent(keyboardEventSource: src, virtualKey: rightArrowKeyCode, keyDown: false)
                    
                        
//                        keyUpEvent?.flags = CGEventFlags.maskCommand
                        keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
                    }
                })
            //                    .assign(to: \.lastUpdated, on: myDataModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
