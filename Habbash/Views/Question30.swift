import SwiftUI
import AVFoundation

struct Question30: View {
    @State private var answer: String = ""
    @State private var isCorrect = false
    @State private var audioPlayer: AVAudioPlayer?
    var onNext: () -> Void = {}

    let questionText = "كم عدد الشهور اللي فيها ٢٨ يوم؟"
    let correctAnswer = "١٢"
    let numberButtons = ["مسح","٩", "٨", "٧", "٦", "٥", "٤", "٣", "٢", "٠", "١","تم"]
    @State private var pageNumber: String = "٣٠"

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text(questionText)
                    .font(.title2)
                    .foregroundColor(.black)

                ZStack {
                    Image("box")
                        .resizable()
                        .frame(width: 300, height: 100)

                    Text(answer)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(numberButtons, id: \.self) { number in
                        Button(action: {
                            handleButtonPress(number)
                        }) {
                            ZStack {
                                Image("numper")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .shadow(radius: 3)

                                Text(number)
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.top, 40)
        }
    }

    func handleButtonPress(_ number: String) {
        switch number {
        case "مسح":
            answer = ""
            isCorrect = false
        case "تم":
            checkAnswer()
        default:
            if answer.count < 3 {
                answer += number
            }
        }
    }

    func checkAnswer() {
        if answer == correctAnswer {
            isCorrect = true
            playSound(isCorrect: true)
            // الانتقال التلقائي بعد نصف ثانية
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                onNext()
            }
        } else {
            isCorrect = false
            playSound(isCorrect: false)
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
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٢٨",
        content: Question30(onNext: {})
    )
}
