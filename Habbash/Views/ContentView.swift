import SwiftUI
import SwiftData

struct ContentView: View {
   
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel: GameViewModel
    @State private var didTapHostQuestionNumberAsCorrect = false
    
    init() {
        do {
            let container = try ModelContainer(for: UserProgress.self)
            let context = ModelContext(container)
            let fetchDescriptor = FetchDescriptor<UserProgress>()
            if let existing = try? context.fetch(fetchDescriptor).first {
                _viewModel = StateObject(wrappedValue: GameViewModel(modelContext: context, userProgress: existing))
            } else {
                let newProgress = UserProgress()
                context.insert(newProgress)
                _viewModel = StateObject(wrappedValue: GameViewModel(modelContext: context, userProgress: newProgress))
            }
            // Ensure the initial screen is splash
            _viewModel.wrappedValue.screen = .splash
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some View {
        switch viewModel.screen {
        case .splash:
            SplashView(
                onFinish: {
                    if viewModel.hasSeenIntroVideos {
                        viewModel.goToStart()
                    } else {
                        viewModel.goToVideo1()
                    }
                },
                viewModel: viewModel
            )
        case .video1:
            VideoView(videoName: "video1", onFinish: { viewModel.goToChoice() })
        case .choice:
            ChoiceScreen(
                onOption1: { viewModel.goToVideo2() },
                onOption2: { viewModel.goToVideo3() }
            )
        case .video2:
            VideoView(videoName: "video2", onFinish: {
                viewModel.hasSeenIntroVideos = true
                viewModel.goToStart()
            })
        case .video3:
            VideoView(videoName: "video3", onFinish: {
                viewModel.hasSeenIntroVideos = true
                viewModel.goToStart()
            })
        case .finalVideo:
            VideoView(videoName: "finalvid", onFinish: { viewModel.goToCongrats() })
        case .congrats:
            CongratsView(onStartOver: { viewModel.goToStart() })
        case .start:
            StartPageView(
                isContinue: viewModel.userProgress.currentQuestion > 0 && viewModel.userProgress.hearts > 0,
                onStart: { viewModel.startGame() },
                onContinue: { viewModel.continueGame() }
            )
        case .gameOver:
            GameOverView(onRestart: {
                viewModel.userProgress.currentQuestion = 0
                viewModel.userProgress.hearts = 3
                viewModel.userProgress.skips = 3
                try? viewModel.modelContext.save()
                viewModel.resetGame()
            })
        case .question:
            if let question = viewModel.currentQuestion {
                switch viewModel.currentQuestionIndex {
                case 3:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question4(viewModel: viewModel, onNext: { viewModel.next() }))
                case 4:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question5(viewModel: viewModel, onNext: { viewModel.next() }))
                case 5:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question6(viewModel: viewModel, onNext: { viewModel.next() }))
                case 7:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question8(onNext: { viewModel.next() }))
                case 9:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question10(onNext: { viewModel.next() }))
                case 11:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question12(onNext: { viewModel.next() }))
                case 12:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question13(onNext: { viewModel.next() }))
                case 14:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question15(onNext: { viewModel.next() }))
                case 16:
                    QuestionHostView(
                        viewModel: viewModel,
                        questionNumber: question.questionNumber,
                        content: Question17(onNext: { viewModel.next() })
                    )
                case 18:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question19(onNext: { viewModel.next() }))
                case 20:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question21(onNext: { viewModel.next() }))
                case 21:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question22(onNext: { viewModel.next() }))
                case 23:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question24(didTapHostQuestionNumberAsCorrect: $didTapHostQuestionNumberAsCorrect, onNext: { viewModel.next() }))
                case 24:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question25(onNext: { viewModel.next() }))
                case 25:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question26(onNext: { viewModel.next() }))
                case 26:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question27(answers: ["القمر", "", "الشمس", "زحل"], onNext: { viewModel.next() }))
                case 27:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question28(onNext: { viewModel.next() }))
                case 29:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question30(onNext: { viewModel.next() }))
                case 30:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question31(onNext: { viewModel.next() }))
                case 33:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question34(onNext: { viewModel.next() }))
                case 35:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question36(onNext: { viewModel.next() }))
                case 36:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question37(onNext: { viewModel.next() }))
                case 37:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question38(onNext: { viewModel.next() }))
                case 39:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question40(onNext: { viewModel.next() }))
                case 40:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question41(onNext: { viewModel.next() }))
                case 41:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question42(onNext: { viewModel.next() }))
                case 42:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question43(viewModel: viewModel, onNext: { viewModel.next() }))
                case 44:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question45(viewModel: viewModel, onNext: { viewModel.next() }))
                case 47:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question48(onNext: { viewModel.next() }))
                case 48:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question49(viewModel: viewModel, onNext: { viewModel.next() }))
                case 49:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question50(onNext: { viewModel.next() }))
                default:
                    QuestionHostView(
                        viewModel: viewModel,
                        questionNumber: question.questionNumber,
                        content: UIMultContent(
                            question: question,
                            onAnswer: { idx in
                                if idx == question.correctAnswerIndex {
                                    viewModel.answer(isCorrect: true)
                                } else {
                                    viewModel.answer(isCorrect: false)
                                }
                            },
                            onSkip: { viewModel.skip() },
                            skips: $viewModel.skips
                        )
                    )
                }
            } else {
                Text("انتهت الأسئلة!")
            }
        default:
            // أي حالة أخرى غير مغطاة
            Text("شاشة غير معروفة")
        }
    }
}

#Preview {
    ContentView()
}
