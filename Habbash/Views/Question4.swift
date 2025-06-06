import SwiftUI
import SwiftData

struct Question4: View {
    @State private var showColors = true
    @ObservedObject var viewModel: GameViewModel
    var onNext: () -> Void

    let correctIndex = 1 // الزر الأخضر (الإجابة الصحيحة)
    let questionText = "ناظر زين!!"
    let questionNumber = "٤"
    let answers = ["", "", "", ""]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 32) {
                Spacer() // يجعل كل شيء في المنتصف عموديًا

                Text(questionText)
                    .font(.custom("BalooBhaijaan2-Medium", size: 30))

                Spacer().frame(height: 10)

                // شبكة 2x2 للأزرار
                VStack(spacing: 24) {
                    HStack(spacing: 24) {
                        answerButton(index: 0)
                        answerButton(index: 1)
                    }
                    HStack(spacing: 24) {
                        answerButton(index: 2)
                        answerButton(index: 3)
                    }
                }

                Spacer() // يجعل كل شيء في المنتصف عموديًا
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .onAppear {
            // إخفاء الألوان بعد ثانية واحدة
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showColors = false
                }
            }
        }
    }

    // زر الإجابة
    func answerButton(index: Int) -> some View {
        Button(action: {
            if !showColors {
                if index == correctIndex {
                    SoundPlayer.playSound(named: "success")
                    viewModel.answer(isCorrect: true)
                } else {
                    SoundPlayer.playSound(named: "failure")
                    viewModel.answer(isCorrect: false)
                }
            }
        }) {
            if showColors {
                Image("BUTTON.REGULAR")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 150, height: 70)
                    .foregroundColor(index == correctIndex ? Color.green.opacity(0.7) : Color.red.opacity(0.7))
            } else {
                Image("BUTTON.REGULAR")
                    .resizable()
                    .frame(width: 150, height: 70)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(showColors)
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
    let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٤",
        content: Question4(viewModel: viewModel, onNext: {})
    )
    .environment(\.modelContext, context)
}
