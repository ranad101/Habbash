import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        switch viewModel.screen {
        case .splash:
            SplashView(onFinish: { viewModel.goToVideo() })
        case .video:
            VideoView(onFinish: { viewModel.goToStart() })
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
            }}}}

#Preview {
    ContentView()
}
