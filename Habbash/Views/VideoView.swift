import SwiftUI
import AVKit

struct LandscapeVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    let onFinish: () -> Void

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.modalPresentationStyle = .fullScreen
        controller.entersFullScreenWhenPlaybackBegins = true
        controller.exitsFullScreenWhenPlaybackEnds = true
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            onFinish()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: ()) {
        NotificationCenter.default.removeObserver(uiViewController, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

struct VideoView: View {
    var videoName: String
    var onFinish: () -> Void
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    private var fileExtension: String {
        if videoName == "video1" {
            return "mov"
        } else {
            return "mp4"
        }
    }

    private var player: AVPlayer {
        if let url = Bundle.main.url(forResource: videoName, withExtension: fileExtension) {
            let player = AVPlayer(url: url)
            player.seek(to: .zero)
            return player
        }
        return AVPlayer()
    }

    var body: some View {
        ZStack {
            LandscapeVideoPlayer(player: player, onFinish: onFinish)
                .ignoresSafeArea()
                .onAppear {
                    player.play()
                }
            if verticalSizeClass == .regular && horizontalSizeClass == .compact {
                // Portrait mode on iPhone
                VStack {
                    Spacer()
                    Text("ممكن تقلب الجوال عشان تستمتع اكثر")
                        .font(.custom("BalooBhaijaan2-Medium", size: 17))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                }
                .transition(.opacity)
            }
        }
    }
}
