import SwiftUI

struct TitleView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                NavigationLink("play on device only") {
                    SingleDeviceView()
                }
                NavigationLink("play on device and external screen") {
                    DeviceWithExternalView()
                }
            }
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
