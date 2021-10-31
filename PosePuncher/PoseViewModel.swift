import AVFoundation
import Foundation
import VideoToolbox
import AppKit

class PoseViewModel: NSObject, ObservableObject {
    private var poseNet: PoseNet!
    private var currentFrame: CGImage?
    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    /// The algorithm the controller uses to extract poses from the current frame.
    private var algorithm: Algorithm = .multiple
    
    override init() {
        super.init()
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
            print("releasing")
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
        print(poses)
    }
}

extension PoseViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        guard currentFrame == nil else {
            return
        }
        //try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            currentFrame = cgImage
            poseNet.predict(cgImage)
        }
    }
}
