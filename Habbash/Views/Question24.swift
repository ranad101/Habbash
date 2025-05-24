import SwiftUI
import AVFoundation

struct Question24: View {
    @State private var selectedAnswer: Int? = nil
    @State private var showFullScreenFeedback = false
    @State private var isCorrectAnswer = false
    @State private var audioPlayer: AVAudioPlayer?
    let answers = ["١٨", "٢٣،٩٣١", "١٢", "مو موجود!!!"]
    let questionText = "٢٥ - ١ = ؟"
    var onNext: () -> Void = {}

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 50) {
                Text(questionText)
                    .font(.custom("BalooBhaijaan2-Medium", size: 26))
                    .padding(.top, 10)
                HStack(spacing: 24) {
                    answerButton(index: 0)
                    answerButton(index: 1)
                }
                HStack(spacing: 24) {
                    answerButton(index: 2)
                    answerButton(index: 3)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .environment(\.layoutDirection, .rightToLeft)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity, alignment: .center)
            if showFullScreenFeedback {
                FullScreenFeedbackView(isCorrect: isCorrectAnswer)
            }
        }
        .ignoresSafeArea()
    }

    func answerButton(index: Int) -> some View {
        Button(action: {
            selectedAnswer = index
            isCorrectAnswer = (index == 0)
            playSound(isCorrect: isCorrectAnswer)
            showFullScreenFeedback = true
            if isCorrectAnswer {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showFullScreenFeedback = false
                    }
                    onNext()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showFullScreenFeedback = false
                    }
                }
            }
        }) {
            Text(answers[index])
                .font(.custom("BalooBhaijaan2-Medium", size: 22))
                .foregroundColor(.white)
                .padding()
                .background(selectedAnswer == index ? (index == 0 ? Color.green : Color.red) : Color.blue)
                .cornerRadius(12)
        }
        .disabled(selectedAnswer != nil)
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

struct FullScreenFeedbackView: View {
    let isCorrect: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 200))
                .foregroundColor(isCorrect ? .green : .red)
        }
    }
}

#Preview {
    Question24()
} 