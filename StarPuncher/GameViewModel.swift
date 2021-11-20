import Foundation
import SpriteKit
import Combine

class GameViewModel: ObservableObject {
    private var poseNet: PoseNet!
    var pose = PassthroughSubject<Pose, Never>()
    let videoService = VideoService()
    let scene: MainScene
    var bag = Set<AnyCancellable>()
    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    
    init() {
        print("Init")
        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        
        scene = MainScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .black
        
        videoService.setUp()
        
        videoService.$currentFrame.compactMap{ $0 }.sink { image in
            self.poseNet.predict(image)
        }.store(in: &bag)
        
        pose.sink { pose in
            self.scene.drawPlayer(pose: pose)
        }.store(in: &bag)
        
        poseNet.delegate = self
    }
}

extension GameViewModel: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
//        print("recieved prediction")
        guard let currentFrame = videoService.currentFrame else {
            return
        }
        
        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: poseBuilderConfiguration,
                                      inputImage: currentFrame)
//        print(poseBuilder.pose)
        pose.send(poseBuilder.pose)
    }
}
