import Combine

struct ButtonEvent: Hashable {
    var keyNUmber: UInt
}

class KeyTracker: ObservableObject {
    @Published var heldKeys = Set<ButtonEvent>()
    
    func keyOn(_ buttonEvent: ButtonEvent) {
        guard !heldKeys.contains(buttonEvent) else {
            return
        }
        heldKeys.insert(buttonEvent)
        print("pressed \(buttonEvent.keyNUmber)")
    }
    
    func keyOff(_ buttonEvent: ButtonEvent) {
        guard heldKeys.contains(buttonEvent) else {
            return
        }
        heldKeys.remove(buttonEvent)
        print("released \(buttonEvent.keyNUmber)")
    }
}
