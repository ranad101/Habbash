import SwiftUI

struct Question22: View {
    @State private var selectedAnswer: Int? = nil
    
    let answers = [
        "نملوكة",
        "ملكة النمل",
        "نملة مرتاحة",
        "نمنة فخمة" // correct
    ]
    let correctIndex = 3
    var onNext: () -> Void = {}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top bar just below dynamic island
               
                
               
                VStack(spacing: 0) {
                    // Question number
                   
                    
                    
                    // Question image
                    Image("ANT22")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 240)
                        .padding(.bottom, 16)
                    
                    // Answer buttons grid
                    VStack(spacing: 20) {
                        HStack(spacing: 24) {
                            answerButton(index: 0)
                            answerButton(index: 1)
                        }
                        HStack(spacing: 24) {
                            answerButton(index: 2)
                            answerButton(index: 3)
                        }
                    }
                    .padding(.horizontal, 16)
                    .environment(\.layoutDirection, .rightToLeft)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity, alignment: .center)
                Spacer(minLength: 150)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }
    
    func answerButton(index: Int) -> some View {
        Button(action: {
            selectedAnswer = index
            if index == correctIndex {
                // الانتقال للسؤال 23 بعد نصف ثانية
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    onNext()
                }
            }
        }) {
            ZStack {
                if selectedAnswer == index && index == correctIndex {
                    Image("BUTTON.CORRECT")
                        .resizable()
                        .frame(height: 70)
                } else {
                    Image("BUTTON.REGULAR")
                        .resizable()
                        .frame(height: 70)
                }
                Text(answers[index])
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٢٢",
        content: Question22(onNext: {})
    )
} 
