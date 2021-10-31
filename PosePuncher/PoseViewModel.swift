import AVFoundation
import Foundation
import VideoToolbox
import AppKit

class PoseViewModel: ObservableObject {
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    /// The algorithm the controller uses to extract poses from the current frame.
    private var algorithm: Algorithm = .multiple
    
    init() {

        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }

        poseNet.delegate = self
        
    }
}

extension PoseViewModel: PoseNetDelegate {
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.currentFrame = nil
        }

        guard let currentFrame = currentFrame else {
            return
        }

        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: poseBuilderConfiguration,
                                      inputImage: currentFrame)

        let poses = algorithm == .single
            ? [poseBuilder.pose]
            : poseBuilder.poses

//        previewImageView.show(poses: poses, on: currentFrame)
    }
}

//extension PoseViewModel: VideoCaptureDelegate {
//    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
//        guard currentFrame == nil else {
//            return
//        }
//        guard let image = capturedImage else {
//            fatalError("Captured image is null")
//        }
//
//        currentFrame = image
//        poseNet.predict(image)
//    }
//}