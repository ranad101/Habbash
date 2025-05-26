import SwiftUI
import AVFAudio

struct Question27: View {
    let answers: [String] // ٤ خيارات مع خيار صورة
    @State private var audioPlayer: AVAudioPlayer?

    @State private var selectedAnswer: Int? = nil
    var onNext: () -> Void = {}

    var correctIndex: Int { 1 } // الخيار الصحيح رقم 1

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("وش أقرب شي لنا؟")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, -40)

                VStack(spacing: 20) {
                    answerButton(index: 0)
                    imageButton(index: 1)
                    answerButton(index: 2)
                    answerButton(index: 3)
                }
                .padding(.horizontal, 30)
                .environment(\.layoutDirection, .rightToLeft)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    func answerButton(index: Int) -> some View {
        Button {
            selectedAnswer = index
            playSound(for: index == correctIndex)
        } label: {
            ZStack {
                Image(selectedAnswer == index && index == correctIndex ? "BUTTON.CORRECT" : "BUTTON.REGULAR")
                    .resizable()
                    .frame(width: 151.68, height: 81)

                Text(answers[index])
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }
        }
    }

    func imageButton(index: Int) -> some View {
        Button {
            selectedAnswer = index
            playSound(for: index == correctIndex)
        } label: {
            ZStack {
                Image(selectedAnswer == index && index == correctIndex ? "BUTTON.CORRECT" : "BUTTON.REGULAR")
                    .resizable()
                    .frame(width: 151.68, height: 81)

                Image("plan")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
            }
            .frame(width: 151.68, height: 90)
        }
    }

    func playSound(for correct: Bool) {
        let soundName = correct ? "success" : "failure"
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        } else {
            print("لم يتم العثور على ملف الصوت \(soundName).wav")
        }
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٢٨",
        content: Question27(
            answers: ["القمر", "", "الشمس", "زحل"],
            onNext: {}
        )
    )
}

