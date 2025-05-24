import SwiftUI

struct UIMultContent: View {
    let question: Question
    let onAnswer: (Int) -> Void
    let onSkip: () -> Void
    @Binding var skips: Int

    @State private var selectedAnswer: Int? = nil
    @State private var isCorrect: Bool? = nil

    var body: some View {
        VStack(spacing: 24) {
            Text(question.questionText)
                .font(.system(size: question.questionFontSize ?? 22, weight: .regular))
                .multilineTextAlignment(.center)
                .padding()

            // 2x2 grid for answer buttons
            ForEach(0..<2) { row in
                HStack(spacing: 16) {
                    ForEach(0..<2) { col in
                        let idx = row * 2 + col
                        if idx < question.answers.count {
                            Button(action: {
                                if selectedAnswer == nil {
                                    selectedAnswer = idx
                                    isCorrect = (idx == question.correctAnswerIndex)
                                    if isCorrect == true {
                                        // Correct: show feedback, then advance
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            onAnswer(idx)
                                        }
                                    } else {
                                        // Wrong: show feedback, then reset selection so user can try again
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            selectedAnswer = nil
                                            isCorrect = nil
                                            onAnswer(idx) // This will deduct a heart
                                        }
                                    }
                                }
                            }) {
                                ZStack {
                                    Image(
                                        selectedAnswer == idx
                                            ? (isCorrect == true && idx == question.correctAnswerIndex ? "BUTTON.CORRECT" : "BUTTON.REGULAR")
                                            : "BUTTON.REGULAR"
                                    )
                                    .resizable()
                                    .frame(width: 151.677, height: 81)
                                    Text(question.answers[idx])
                                        .foregroundColor(.white)
                                        .font(.system(size: question.answerFontSizes?[idx] ?? 20, weight: .bold))
                                        .bold()
                                }
                            }
                            .disabled(isCorrect == true)
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding()
        // Reset state when question changes
        .onChange(of: question.id) { _ in
            selectedAnswer = nil
            isCorrect = nil
        }
    }
}

#Preview {
    @State var skips = 3
    return UIMultContent(
        question: Question(
            id: 1,
            questionText: "كيف تبدأ اللعبة ؟",
            answers: ["زي كذا", "بحذر", "بروقان", "بثقة"],
            correctAnswerIndex: 0,
            questionNumber: "١"
        ),
        onAnswer: { _ in },
        onSkip: {},
        skips: $skips
    )
}
