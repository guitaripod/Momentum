import SwiftUI

@main
struct MomentumApp: App {
    var body: some Scene {
        WindowGroup {
            TimerView()
                .frame(minWidth: 700, minHeight: 420)
        }
    }
}
