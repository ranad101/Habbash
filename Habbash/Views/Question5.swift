import SwiftUI
import SwiftData

struct Question5: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var foundCat = false
    @State private var showFailure = false
    @State private var catPosition: CGPoint = .zero
    @State private var screenSize: CGSize = .zero
    let catSize: CGFloat = 170
    let tapRadius: CGFloat = 90
    var onNext: () -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if foundCat {
                    Image("hiddenimage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: catSize, height: catSize)
                        .position(catPosition)
                        .transition(.scale)
                }
                VStack {
                    HStack {
                        Spacer()
                        Text("وين القطوة؟")
                            .font(.custom("BalooBhaijaan2-Medium", size: 32))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.top, 40)
                    Spacer()
                    if showFailure {
                        Text("مو هنا!")
                            .font(.title2)
                            .foregroundColor(.red)
                            .transition(.opacity)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { location in
                if foundCat { return }
                let tapPoint = location
                let distance = hypot(tapPoint.x - catPosition.x, tapPoint.y - catPosition.y)
                if distance < tapRadius {
                    foundCat = true
                    SoundPlayer.playSound(named: "success")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        onNext()
                    }
                } else {
                    showFailure = true
                    SoundPlayer.playSound(named: "failure")
                    viewModel.answer(isCorrect: false)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        showFailure = false
                    }
                }
            }
            .onAppear {
                screenSize = geo.size
                // Place the cat at a fixed position on the left side of the screen
                let margin: CGFloat = 60
                let x = margin + catSize / 2
                let y = geo.size.height / 2 + 60
                catPosition = CGPoint(x: x, y: y)
            }
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
        questionNumber: "٥",
        content: Question5(viewModel: viewModel, onNext: {})
    )
    .environment(\.modelContext, context)
}

