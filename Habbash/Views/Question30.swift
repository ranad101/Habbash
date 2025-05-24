import SwiftUI
import AVFoundation

struct Question30: View {
    @State private var answer: String = ""
    @State private var isCorrect = false
    @State private var audioPlayer: AVAudioPlayer?
    let questionText = "كم عدد الشهور اللي فيها ٢٨ يوم؟"
    let correctAnswer = "١٢"
    let numberButtons = ["مسح","٩", "٨", "٧", "٦", "٥", "٤", "٣", "٢", "٠", "١","تم"]
    var onNext: () -> Void = {}
    var body: some View {
        VStack(spacing: 10) {
            Text(questionText)
                .font(.custom("BalooBhaijaan2-Medium", size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
            ZStack {
                Image("box")
                    .resizable()
                    .frame(width: 300, height: 100)
                Text(answer)
                    .font(.custom("BalooBhaijaan2-Medium", size: 36))
                    .foregroundColor(.black)
            }
            Spacer()
            // Number pad
            VStack(spacing: 8) {
                ForEach(0..<4) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<3) { col in
                            let idx = row * 3 + col
                            if idx < numberButtons.count {
                                Button(action: {
                                    handleButtonTap(numberButtons[idx])
                                }) {
                                    Text(numberButtons[idx])
                                        .font(.custom("BalooBhaijaan2-Medium", size: 24))
                                        .frame(width: 70, height: 50)
                                        .background(Color.blue.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
    func handleButtonTap(_ value: String) {
        if value == "مسح" {
            answer = ""
        } else if value == "تم" {
            isCorrect = (answer == correctAnswer)
            playSound(isCorrect: isCorrect)
            if isCorrect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    onNext()
                }
            } else {
                answer = ""
            }
        } else {
            answer += value
        }
    }
    func playSound(isCorrect: Bool) {
        let soundName = isCorrect ? "success" : "failure"
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
}

#Preview {
    Question30()
} 