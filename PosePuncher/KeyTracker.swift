import Foundation
import Combine

struct ButtonEvent: Hashable {
    var keyNUmber: UInt16
}

class KeyTracker: ObservableObject {
    @Published var heldKeys = Set<ButtonEvent>()
    
    func keyOn(_ buttonEvent: ButtonEvent) {
        guard !heldKeys.contains(buttonEvent) else {
            return
        }
        heldKeys.insert(buttonEvent)
        print("pressed \(buttonEvent.keyNUmber)")
        let src = CGEventSource(stateID: .privateState)
        let keyDownEvent = CGEvent(keyboardEventSource: src, virtualKey: buttonEvent.keyNUmber, keyDown: true)
        keyDownEvent?.setSource(src)
        keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        
    }
    
    func keyOff(_ buttonEvent: ButtonEvent) {
        guard heldKeys.contains(buttonEvent) else {
            return
        }
        let src = CGEventSource(stateID: .privateState)
            
        let keyUpEvent = CGEvent(keyboardEventSource: src, virtualKey: buttonEvent.keyNUmber, keyDown: false)
            keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    
        heldKeys.remove(buttonEvent)
        print("released \(buttonEvent.keyNUmber)")
    }
}
