import Foundation
import SpriteKit
import Combine

class GameViewModel: ObservableObject {
    private var poseNet: PoseNet!
    @Published var pose = Pose()
    let videoService = VideoService()
    let scene: MainScene
    var bag = Set<AnyCancellable>()
    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    
    init() {
        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        print("Init")
        scene = MainScene()
        poseNet.delegate = self
    }
    
    func setUpCamera() {
        videoService.setUp()
        
        videoService.$currentFrame.compactMap{ $0 }.sink { image in
            self.poseNet.predict(image)
        }.store(in: &bag)
    }
    
    func setUpScene(size: CGSize) {

        scene.size = size
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .black
        
        $pose.sink { pose in
            self.scene.player.drawPlayer(pose: pose, scene: self.scene)
        }.store(in: &bag)
    }
}

extension GameViewModel: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.videoService.currentFrame = nil
        }
        guard let currentFrame = videoService.currentFrame else {
            return
        }
        
        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: poseBuilderConfiguration,
                                      inputSize: currentFrame.size)//scene.size
        pose = poseBuilder.pose
    }
}
