import SwiftUI
import AVFoundation
import SwiftData

struct Question24: View {
    @State private var skipCount = 0
    @State private var selectedAnswer: Int? = nil // هذا سيظل لخيارات الإجابة العادية
    @State private var showFullScreenFeedback = false
    @State private var isCorrectAnswerForOption: Bool = false // لتوضيح أنها تخص خيارات الأجوبة
    @State private var audioPlayer: AVAudioPlayer?

    @Binding var didTapHostQuestionNumberAsCorrect: Bool // تم تغيير الاسم ليكون أوضح

    let answers = ["١٨", "٢٣،٩٣١", "١٢", "مو موجود!!!"] // مصفوفة الخيارات الأصلية، بدون "٢٤"
    let questionText = "٢٥ - ١ = ؟"
    let maxSkips = 6
    var onNext: () -> Void = {}

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack() {
                    VStack(spacing: 50) {
                        Text(questionText)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)

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

                    
                    .padding(.bottom, 50)
                    
                }

                // ⭐️ إظهار علامة الصح الكبيرة في منتصف Question24
                // عندما يتم الضغط على رقم السؤال (٢٤) في QuestionHostView ويعتبر إجابة صحيحة.
                if didTapHostQuestionNumberAsCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80)) // حجم كبير
                        .foregroundColor(.green)
                        .transition(.scale.animation(.easeOut)) // تأثير سلس
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // في المنتصف
                }
            }
            .overlay(
                Button(action: {
                    onNext()
                }) {
                    Color.clear
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
                // يمكنك إظهار صورة مختلفة للزر إذا كانت الإجابة خاطئة
                if selectedAnswer == index { // إذا تم اختيار هذا الزر
                    Image("BUTTON.REGULAR") // يمكنك استخدام صورة "BUTTON.INCORRECT" إذا كانت متوفرة
                        .resizable()
                        .frame(width: 151.68, height: 81)
                } else {
                    Image("BUTTON.REGULAR")
                        .resizable()
                        .frame(width: 151.68, height: 81)
                }

                Text(answers[index])
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
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
