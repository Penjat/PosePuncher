import UIKit

class StarAppDelegate: NSObject, UIApplicationDelegate {
    var additionalWindows = [UIWindow]()
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification,
                                               object: nil, queue: nil) { (notification) in
            //            let newScreen = notification.object as! UIScreen
            //               let screenDimensions = newScreen.bounds
            //
            //
            //
            //            print("Screen connected \(screenDimensions)")
            // Configure a window for the screen.
            //            let newWindow = UIWindow(frame: screenDimensions)
            //               newWindow.screen = newScreen
            //            newWindow.windowScene
            //               // Install a custom root view controller in the window.
            ////                   self.configureAuxilliaryInterface(with: newWindow)
            //            newWindow.rootViewController = TestViewController.init()
            //
            //               // You must show the window explicitly.
            //               newWindow.isHidden = false
            //               // Save a reference to the window in a local array.
            ////                   self.additionalWindows.append(newWindow)}
            //            newWindow.makeKeyAndVisible()
            
            guard let newScreen = notification.object as? UIScreen else {return}
            // Give the system time to update the connected scenes
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Find matching UIWindowScene
                let matchingWindowScene = UIApplication.shared.connectedScenes.first {
                    guard let windowScene = $0 as? UIWindowScene else { return false }
                    return windowScene.screen == newScreen
                } as? UIWindowScene
                
                guard let connectedWindowScene = matchingWindowScene else {
                    fatalError("Connected scene was not found") // You might want to retry here after some time
                }
                let screenDimensions = newScreen.bounds
                
                let newWindow = UIWindow(frame: screenDimensions)
                newWindow.windowScene = connectedWindowScene
                self.configureInterface(window: newWindow)
                
                
                
//                newWindow.makeKeyAndVisible()
                
                newWindow.isHidden = false
                self.additionalWindows.append(newWindow)
            }
        }
        
        
        
        
        NotificationCenter.default.addObserver(forName:
                                                    UIScreen.didDisconnectNotification,
                    object: nil,
                    queue: nil) { (notification) in
           let screen = notification.object as! UIScreen

           // Remove the window associated with the screen.
           for window in self.additionalWindows {
              if window.screen == screen {
                 // Remove the window and its contents.
                 let index = self.additionalWindows.index(of: window)
                 self.additionalWindows.remove(at: index!)
              }
           }
        }
        print("Appdelegate loaded")
        return true
    }
    
    func configureInterface(window: UIWindow) {
        window.rootViewController = TestViewController.init(number: 0)
    }
}
