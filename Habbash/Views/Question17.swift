import SwiftUI
import SwiftData
import AVFoundation

struct Question17: View {
    let numbers = [-694, 250, -459, -365, 1200, 554]
    
    @State private var selectedOrder: [Int] = []
    @State private var isCorrect = false
    @State private var audioPlayer: AVAudioPlayer?
    var onNext: () -> Void = {}

    var body: some View {
        VStack(spacing: 90) {
            Text("رتبهم من الأقل إلى الأعلى")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            VStack {
                ForEach(Array(numbers.reversed()), id: \.self) { number in
                    let selectionIndex = selectedOrder.firstIndex(of: number)

                    HStack {
                        Spacer()
                        Text("\(number)")
                            .font(.title3)
                        Spacer()
                        if let index = selectionIndex {
                            // صورة ديناميكية بحسب الترتيب
                            Image("circle2\(index + 1)")
                                .resizable()
                                .frame(width: 24, height: 24)
                        } else {
                            Spacer().frame(width: 24) // للحفاظ على التوازن
                        }
                    }
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard !isCorrect, !selectedOrder.contains(number) else { return }
                        selectedOrder.append(number)
                    }
                    .disabled(isCorrect)
                }
            }
            .padding(.horizontal)

            Button(action: {
                if selectedOrder.count == numbers.count {
                    checkFinalOrder()
                } else {
                    print("الرجاء اختيار جميع الأرقام أولاً")
                }
            }) {
                Image("okay") // صورة زر التحقق
                    .resizable()
                    .frame(width: 100, height: 50)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isCorrect)
        }
        .padding()
    }

    func checkFinalOrder() {
        let isOrderCorrect = selectedOrder == numbers.sorted()
        if isOrderCorrect {
            playSound(isCorrect: true)
            print("الإجابة صحيحة!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                onNext()
            }
            isCorrect = true
        } else {
            playSound(isCorrect: false)
            print("الإجابة خاطئة!")
        }
    }

    func playSound(isCorrect: Bool) {
        let soundName = isCorrect ? "success" : "failure"
        if let url = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("خطأ في تشغيل الصوت: \(error)")
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProgress.self, configurations: config)
    let userProgress = UserProgress()
    container.mainContext.insert(userProgress)
    
    return QuestionHostView(
        viewModel: GameViewModel(modelContext: container.mainContext, userProgress: userProgress),
        questionNumber: "١٧",
        content: Question17(onNext: {})
    )
}
