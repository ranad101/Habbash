import SwiftUI
import AVFAudio

struct Question27: View {
    let answers: [String] // 4 عناصر – واحد منهم يكون للصورة ويكون محتواه ""
    var imageName: String? = nil
    var onNext: () -> Void = {}

    @State private var selectedAnswer: Int? = nil
    @State private var showFullScreenFeedback = false

    var correctIndex: Int {
        return 1 // ← الطيارة في الخيار الثاني
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                // Question image (if any)
                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .padding(.bottom, 16)
                }
                // Answer buttons
                VStack(spacing: 20) {
                    ForEach(0..<answers.count, id: \.self) { i in
                        Button(action: {
                            selectedAnswer = i
                            showFullScreenFeedback = true
                            if i == correctIndex {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    showFullScreenFeedback = false
                                    onNext()
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    showFullScreenFeedback = false
                                    selectedAnswer = nil
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
                Spacer()
            }
            if showFullScreenFeedback {
                FullScreenFeedbackView(isCorrect: selectedAnswer == correctIndex)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Question27(answers: ["", "طيارة", "سيارة", "دراجة"], onNext: {})
} 