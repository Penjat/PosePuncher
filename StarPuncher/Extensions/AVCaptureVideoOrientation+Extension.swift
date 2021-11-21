import AVFoundation
import UIKit

extension AVCaptureVideoOrientation {
    init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .landscapeLeft:
            self = .landscapeLeft
        case .landscapeRight:
            self = .landscapeRight
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        default:
            self = .portrait
        }
    }
}

extension CGPoint {
  func midBetween(_ other: CGPoint) -> CGPoint {
    return CGPoint(x: (self.x + other.x) / 2.0,
                   y: (self.y + other.y) / 2.0)
  }
}
