import SwiftUI
import SwiftData
struct Question13: View {
    @State private var answerState: AnswerState? = nil
    var onNext: () -> Void

    enum AnswerState: Equatable {
        case correct
        case wrong(index: Int)

        static func == (lhs: AnswerState, rhs: AnswerState) -> Bool {
            switch (lhs, rhs) {
            case (.correct, .correct):
                return true
            case let (.wrong(i1), .wrong(i2)):
                return i1 == i2
            default:
                return false
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                Spacer().frame(height: 40)
                // Question text + النقطة السوداء فوق العين
                ZStack {
                    Text("دور أصعر دائره")
                        .font(.custom("BalooBhaijaan2-Medium", size: 24))
                        .padding(.top, -1)
                    // النقطة السوداء (الجواب الصحيح)
                    Button(action: {
                        answerState = .correct
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            onNext()
                        }
                    }) {
                        Circle()
                            .fill(answerState == .correct ? Color.green : Color.black)
                            .frame(width: 4, height: 7)
                    }
                    .offset(x: -3, y: -10)
                }
                // الدوائر الزرقاء في منتصف الشاشة وأعلى قليلاً
                ZStack {
                    circleButton(index: 0)
                        .offset(x: 100, y: 90)
                    circleButton(index: 1)
                        .offset(x: -100, y: -20)
                    circleButton(index: 2)
                        .offset(x: -90, y: 120)
                    circleButton(index: 3)
                        .offset(x: 50, y: -40)
                }
                .frame(height: geo.size.height * 0.35)
                .frame(maxWidth: .infinity)
                .offset(y: 40) // <-- تم تحريك الدوائر للأسفل هنا

                Spacer()
                // Feedback
                if answerState == .correct {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                }
            }
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }

    // Circle button
    func circleButton(index: Int) -> some View {
        Button(action: {
            answerState = .wrong(index: index)
        }) {
            Image("circle\(index+1)")
                .resizable()
                .frame(width: CGFloat(160 - index * 30), height: CGFloat(160 - index * 30))
                .overlay(
                    Circle()
                        .fill(answerState == .wrong(index: index) ? Color.red.opacity(0.4) : Color.clear)
                )
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
        questionNumber: "١٣",
        content: Question13(onNext: {})
    )
    .environment(\.modelContext, context)
}
