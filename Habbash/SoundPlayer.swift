import AVFoundation

class SoundPlayer {
    static var player: AVAudioPlayer?

    static func playSound(named name: String, withExtension ext: String = "wav") {
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Could not play sound: \(error)")
            }
        } else {
            print("Sound file \(name).\(ext) not found")
        }
    }
} 