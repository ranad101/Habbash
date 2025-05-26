import SwiftUI

struct Question4: View {
    @State private var showColors = true
    var onNext: () -> Void

    let correctIndex = 3 // الزر الأخضر (الإجابة الصحيحة)
    let questionText = "ناظر زين!!"
    let questionNumber = "٤"
    let answers = ["", "", "", ""]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 32) {
                Spacer().frame(height: geo.size.height * 0.03) // رفع بسيط للأعلى

                Text(questionText)
                    .font(.title2)

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

                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .onAppear {
            // إخفاء الألوان بعد ثانية واحدة
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showColors = false
                }
            }
        }
    }

    // زر الإجابة
    func answerButton(index: Int) -> some View {
        Button(action: {
            if index == correctIndex && !showColors {
                onNext()
            }
        }) {
            if showColors {
                Image("BUTTON.REGULAR")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 150, height: 70) // <-- هنا التعديل
                    .foregroundColor(index == correctIndex ? Color.green.opacity(0.7) : Color.red.opacity(0.7))
            } else {
                Image("BUTTON.REGULAR")
                    .resizable()
                    .frame(width: 150, height: 70) // <-- هنا التعديل
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(showColors)
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٤",
        content: Question4(onNext: {})
    )
}

