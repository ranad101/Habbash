import SwiftUI
import AVKit

struct GameOverView: View {
    @State private var player: AVPlayer?
    var onRestart: () -> Void

    var body: some View {
        ZStack {
            Color(hex: "#F8B933").ignoresSafeArea()
            StarField()
            VStack(spacing: 30) {
                Text("فاز عليك هبّاش")
                    .font(.custom("BalooBhaijaan2-Medium", size: 48))
                    .foregroundColor(Color(hex: "#83300E"))
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 1)
                if let player = player {
                    VideoPlayer(player: player)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 400, height: 216)
                        .clipped()
                        .cornerRadius(15)
                }
                Button(action: onRestart) {
                    Image("restart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 80)
                }
            }
        }
        .onAppear {
            if let videoURL = Bundle.main.url(forResource: "gameover", withExtension: "mp4") {
                player = AVPlayer(url: videoURL)
                player?.play()
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

#Preview {
    GameOverView(onRestart: {})
}
