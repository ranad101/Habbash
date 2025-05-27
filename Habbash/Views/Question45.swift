import SwiftUI
import SwiftData
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
    let backgroundOffsetY: CGFloat = 0 // Move background 30 points down
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
        
        
            Image("background1")
            .padding(.bottom, 50)
                
        
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
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
       let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٤٥",
        content: Question45(viewModel: viewModel, onNext: {})
    )
    .environment(\.modelContext, context)
}
