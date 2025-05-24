import SwiftUI

struct Question5: View {
    var onNext: () -> Void
    @State var skips: Int = 3
    var body: some View {
        UIMultContent(
            question: Question(
                id: 5,
                questionText: "ما هو لون السماء؟",
                answers: ["أزرق", "أحمر", "أخضر", "أصفر"],
                correctAnswerIndex: 0,
                questionNumber: "٥"
            ),
            onAnswer: { _ in onNext() },
            onSkip: { },
            skips: $skips
        )
    }
}

#Preview {
    Question5(onNext: {})
}

