import SwiftUI
import AVFoundation
import SwiftData

struct Question34: View {
    @State private var selectedCircles: Set<Int> = []
    @State private var audioPlayer: AVAudioPlayer?
    @State private var cupCount: Int = 0

    var onNext: () -> Void = {}

    var body: some View {
        VStack() {  // غيرت spacing لسالب 100 لرقم إيجابي
            Text("كم فتحه بالفروه")
                .font(.largeTitle)
            ZStack {
                Image("fro")
                    .frame(width: 300, height: 300)
                ForEach(1..<9) { number in
                    numberedCircle(number: number,
                                   x: CGFloat(50 * (number % 3 - 1)),
                                   y: CGFloat(50 * (number / 3 - 1)))
                }
            }
            .padding()

            HStack() {
                Button(action: {
                    if cupCount > 0 {
                        cupCount -= 1
                    }
                }) {
                    Image("minus6")
                        .resizable()
                        .frame(width: 42, height: 40)
                }

                Text("\(cupCount)")
                    .font(.largeTitle)

                Button(action: {
                    cupCount += 1
                }) {
                    Image("plus6")
                        .resizable()
                        .frame(width: 42, height: 40)
                }
            }

            Button(action: {
                checkAnswer()
            }) {
                Image("okay")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 50)
            }
            .padding(.top, 30)  // غيرت من 99 ل 30 لراحة العرض
        }
    }

    func numberedCircle(number: Int, x: CGFloat, y: CGFloat) -> some View {
        Button(action: {
            if selectedCircles.contains(number) {
                selectedCircles.remove(number)
            } else {
                selectedCircles.insert(number)
            }
        }) {
            Image("circleImage") // استبدل "circleImage" باسم صورة الدائرة الصحيحة
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .opacity(selectedCircles.contains(number) ? 1.0 : 0.5)
        }
        .offset(x: x, y: y)
    }

    func checkAnswer() {
        if cupCount == 8 {
            playSound(isCorrect: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                onNext()
            }
        } else {
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
        } else {
            print("لم يتم العثور على ملف الصوت \(soundName).wav")
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
        let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
        QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٣٤",
        content: Question34(onNext: {})
    )
    .environment(\.modelContext, context)
}
