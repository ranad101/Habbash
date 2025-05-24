import SwiftUI

struct ContentView: View {
    init() {
        print("Available fonts:")
        for family in UIFont.familyNames.sorted() {
            print("\nFamily: \(family)")
            for name in UIFont.fontNames(forFamilyName: family).sorted() {
                print("  \(name)")
            }
        }
    }
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        switch viewModel.screen {
        case .splash:
            SplashView(onFinish: { viewModel.goToVideo1() })
        case .video1:
            VideoView(videoName: "video1", onFinish: { viewModel.goToChoice() })
        case .choice:
            ChoiceScreen(
                onOption1: { viewModel.goToVideo2() },
                onOption2: { viewModel.goToVideo3() }
            )
        case .video2:
            VideoView(videoName: "video2", onFinish: { viewModel.goToStart() })
        case .video3:
            VideoView(videoName: "video3", onFinish: { viewModel.goToStart() })
        case .start:
            StartPageView(onStart: { viewModel.startGame() })
        case .gameOver:
            GameOverView(onRestart: { viewModel.resetGame() })
        case .question:
            if let question = viewModel.currentQuestion {
                switch viewModel.currentQuestionIndex {
                case 4:
                    QuestionHostView(
                        viewModel: viewModel,
                        questionNumber: question.questionNumber,
                        content: Question5(onNext: { viewModel.goToNextQuestion() })
                    )
                case 7:
                    QuestionHostView(
                        viewModel: viewModel,
                        questionNumber: question.questionNumber,
                        content: Question8(onNext: { viewModel.goToNextQuestion() })
                    )
                case 9:
                    QuestionHostView(
                        viewModel: viewModel,
                        questionNumber: question.questionNumber,
                        content: Question10(onNext: { viewModel.goToNextQuestion() })
                    )
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
        }
    }
}

#Preview {
    ContentView()
}
