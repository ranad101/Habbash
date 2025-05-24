import SwiftUI

struct StartPageView: View {
    var onStart: () -> Void

    var body: some View {
        VStack {
            Text("Start Page")
                .font(.largeTitle)
                .padding()
            Button("Start Game") {
                onStart()
            }
        }
    }
}
