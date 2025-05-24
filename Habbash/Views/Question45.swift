import SwiftUI

struct Question45: View {
    @State private var selected: Int? = nil
    @State private var isCorrect: Bool? = nil
    @State private var showFeedback: Bool = false
    @ObservedObject var viewModel: GameViewModel
    
    let answers = [
        "خشيم النوم", // Top left
        "وادي بقر",   // Top right
        "مطرفه",      // Bottom left (correct)
        "محير الترمس" // Bottom right
    ]
    let correctIndex = 2
    // Adjustable positions for each answer (relative to geometry size)
    @State private var positions: [CGPoint] = [
        CGPoint(x: 0.28, y: 0.54), // Top left
        CGPoint(x: 0.72, y: 0.54), // Top right
        CGPoint(x: 0.28, y: 0.676), // Bottom left
        CGPoint(x: 0.725, y: 0.676)  // Bottom right
    ]
    // Adjustable background offsets
    let backgroundOffsetX: CGFloat = -1
    let backgroundOffsetY: CGFloat = 50 // Move background 30 points down
    var onNext: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 32) {
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 24) {
                ForEach(0..<4) { i in
                    answerText(index: i)
                        .onTapGesture {
                            if selected == nil {
                                selected = i
                                if i == correctIndex {
                                    SoundPlayer.playSound(named: "success")
                                    viewModel.answer(isCorrect: true)
                                } else {
                                    SoundPlayer.playSound(named: "failure")
                                    viewModel.answer(isCorrect: false)
                                }
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .background(
            Image("Q45.BACKGROUND")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
    }
    
    func answerText(index: Int) -> some View {
        Text(answers[index])
            .font(.custom("BalooBhaijaan2-Medium", size: 20))
            .foregroundColor(.white)
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(selected == index ? (isCorrect == true && index == correctIndex ? Color.green : Color.red) : Color.blue)
            .cornerRadius(12)
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٤٥",
        content: Question45(viewModel: GameViewModel(), onNext: {})
    )
}
