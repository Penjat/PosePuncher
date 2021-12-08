import Combine

enum GameStage {
    case menu
    case playing
    case gameover
    //case highscore
}

class GameStageModel: ObservableObject {
    @Published var gameStage: GameStage = .menu
}
