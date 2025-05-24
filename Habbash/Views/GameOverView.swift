import SwiftUI

struct GameOverView: View {
    var onRestart: () -> Void

    var body: some View {
        VStack {
            Text("Game Over!")
                .font(.largeTitle)
                .padding()
            Button("Restart") {
                onRestart()
            }
        }
    }
}
