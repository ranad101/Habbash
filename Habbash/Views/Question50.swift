import SwiftUI
import AVFoundation

struct Question50: View {
    @State private var answer: String = ""
    @State private var isCorrect = false
    @State private var audioPlayer: AVAudioPlayer?
    var onNext: () -> Void = {}

    let correctAnswer = "٢٤٨٩"
    let numberButtons = ["٩", "٨", "٧", "٦", "٥", "٤", "٣", "٢", "١", "٠", "تم"]
    @State private var pageNumber: String = "٥٠"

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 4)
                ZStack {
                    Image("phone")
                        
                        .aspectRatio(contentMode: .fit)
                        .frame(height: geometry.size.height * 0.48)
                    // Show the entered code on the phone screen
                    VStack {
                        Spacer().frame(height: geometry.size.height * 0.16)
                        Text(answer)
                            .font(.custom("BalooBhaijaan2-Medium", size: 38))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }
                Spacer(minLength: 4)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(numberButtons, id: \.self) { number in
                        Button(action: {
                            handleButtonPress(number)
                        }) {
                            ZStack {
                                Image("numper")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .shadow(radius: 3)
                                Text(number)
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 70)
                Spacer()
            }
        }
    }

    func handleButtonPress(_ number: String) {
        switch number {
        case "تم":
            checkAnswer()
        default:
            if answer.count < 4 {
                answer += number
            }
        }
    }

    func checkAnswer() {
        if answer == correctAnswer {
            isCorrect = true
            playSound(isCorrect: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                onNext()
            }
        } else {
            isCorrect = false
            playSound(isCorrect: false)
            answer = ""
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
        questionNumber: "٥٠",
        content: Question50(onNext: {})
    )
} 
