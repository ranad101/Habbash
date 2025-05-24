import SwiftUI
import AVKit

struct VideoView: View {
    var onFinish: () -> Void

    private var player: AVPlayer {
        if let url = Bundle.main.url(forResource: "video1", withExtension: "mov") {
            return AVPlayer(url: url)
        }
        return AVPlayer()
    }

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
                    onFinish()
                }
            }
            .ignoresSafeArea()
    }
}
