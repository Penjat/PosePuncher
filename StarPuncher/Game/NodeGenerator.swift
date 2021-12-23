import Foundation

struct NodeGenerator {
    let wav: (Double) -> Double
}

enum SectonType: CaseIterable {
    case single
    case symetrical
    case doubleSymetrical
    
    var generators: [NodeGenerator] {
        switch self {
        case .single:
            let wav = randomWav
            return [NodeGenerator(wav: {(wav($0)+1)/2 })]
        case .symetrical:
            let wav = [sin, triangleWave, sawWave].randomElement() ?? sin
            return [
                NodeGenerator(wav: {(wav($0)+1)/2 }),
                NodeGenerator(wav: {1 - (wav($0)+1)/2 })]
        case .doubleSymetrical:
            let wav = [sin, triangleWave, squareWave].randomElement() ?? sin
            return [
                NodeGenerator(wav: {(wav($0)+1.5)/4 }),
                NodeGenerator(wav: {1 - (wav($0)+1)/4 })]
        }
    }
    
    private var randomWav: (Double) -> Double {
        [sin, triangleWave, sawWave, {(squareWave($0) + 0.5)/2}, noise].randomElement() ?? sin
    }
}
