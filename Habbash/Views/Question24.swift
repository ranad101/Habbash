import SwiftUI
import AVFoundation
import SwiftData

struct Question24: View {
    @State private var skipCount = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showFullScreenFeedback = false
    @State private var isCorrectAnswerForOption: Bool = false
    @State private var audioPlayer: AVAudioPlayer?

    @Binding var didTapHostQuestionNumberAsCorrect: Bool

    let answers = ["١٨", "٢٣،٩٣١", "١٢", "مو موجود!!!"]
    let questionNumber = ""
    
    let questionText = "٢٥ - ١ = ؟"
    let maxSkips = 6
    var onNext: () -> Void = {}

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .trailing, spacing: 30) {
                    // رقم السؤال مع زر شفاف فوقه
                    ZStack(alignment: .topTrailing) {
                        Text(questionNumber)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            .padding(.trailing, 16)

                        Button(action: {
                            didTapHostQuestionNumberAsCorrect = true
                        }) {

                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                        .padding(.top, -40)
                    }
                    
                    Spacer().frame(height: 20)
                    
                    // نص السؤال
                    Text(questionText)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                        .frame(maxWidth: .infinity)

                    // خيارات الإجابة
                    VStack(spacing: 33) {
                        HStack(spacing: 33) {
                            answerButton(index: 0)
                            answerButton(index: 1)
                        }
                        HStack(spacing: 33) {
                            answerButton(index: 2)
                            answerButton(index: 3)
                        }
                    }
                    .padding(.horizontal, 33)
                    
                }
                .padding(.bottom, 160)
                
                // علامة الصح الكبيرة تظهر عند الضغط على زر رقم السؤال
                if didTapHostQuestionNumberAsCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                        .transition(.scale.animation(.easeOut))
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
            .overlay(
                Button(action: {
                    onNext()
                }) {
                    Color.white.opacity(0.1) // Use red for debugging, change to .clear when done
                        .frame(width: 60, height: 60)
                }
                .buttonStyle(PlainButtonStyle())
                .position(x: geometry.size.width - 24 - 21, y: -20)
            )
        }
        .ignoresSafeArea()
    }

    func answerButton(index: Int) -> some View {
        Button(action: {
            selectedAnswer = index
            isCorrectAnswerForOption = false
            playSound(isCorrect: false)
        }) {
            ZStack {
                Image("BUTTON.REGULAR")
                    .resizable()
                    .frame(width: 151.68, height: 81)
                Text(answers[index])
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(showFullScreenFeedback)
    }

    func playSound(isCorrect: Bool) {
        let soundName = isCorrect ? "success" : "failure"
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
}

// المعاينة (تأكد أن QuestionHostView و GameViewModel موجودين بمشروعك)
#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
        let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
        QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٢٤",
        content: Question24(didTapHostQuestionNumberAsCorrect: .constant(false), onNext: {})
    )
    .environment(\.modelContext, context)
}
