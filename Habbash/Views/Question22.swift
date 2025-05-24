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
                Spacer(minLength: 0)
                // Question text
                Text("أي من هذه هي نمنة فخمة؟")
                    .font(.custom("BalooBhaijaan2-Medium", size: 26))
                    .padding(.top, 10)
                // Answer buttons
                VStack(spacing: 24) {
                    ForEach(0..<answers.count, id: \.self) { i in
                        Button(action: {
                            selectedAnswer = i
                            if i == correctIndex {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    onNext()
                                }
                            }
                        }) {
                            Text(answers[i])
                                .font(.custom("BalooBhaijaan2-Medium", size: 22))
                                .foregroundColor(.white)
                                .padding()
                                .background(selectedAnswer == i ? (i == correctIndex ? Color.green : Color.red) : Color.blue)
                                .cornerRadius(12)
                        }
                        .disabled(selectedAnswer != nil)
                    }
                }
                .padding(.top, 32)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Question22()
} 