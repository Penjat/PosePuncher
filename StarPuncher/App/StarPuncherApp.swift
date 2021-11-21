import SwiftUI

@main
struct StarPuncherApp: App {
    @UIApplicationDelegateAdaptor var delegate: StarAppDelegate 
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
