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
                    QuestionHostView(viewModel: viewModel, questionNumber: "٥", content: Question5(viewModel: viewModel, onNext: { viewModel.goToNextQuestion() }))
                case 5:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٦", content: Question6(onNext: { viewModel.goToNextQuestion() }))
                case 7:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٨", content: Question8(onNext: { viewModel.goToNextQuestion() }))
                case 9:
                    QuestionHostView(viewModel: viewModel, questionNumber: "١٠", content: Question10(onNext: { viewModel.goToNextQuestion() }))
                case 11:
                    QuestionHostView(viewModel: viewModel, questionNumber: "١٢", content: Question12(onNext: { viewModel.goToNextQuestion() }))
                case 12:
                    QuestionHostView(viewModel: viewModel, questionNumber: "١٣", content: Question13(onNext: { viewModel.goToNextQuestion() }))
                case 14:
                    QuestionHostView(viewModel: viewModel, questionNumber: question.questionNumber, content: Question15(onNext: { viewModel.goToNextQuestion() }))
                case 18:
                    QuestionHostView(viewModel: viewModel, questionNumber: "١٩", content: Question19(onNext: { viewModel.goToNextQuestion() }))
                case 20:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٢١", content: Question21(onNext: { viewModel.goToNextQuestion() }))
                case 21:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٢٢", content: Question22(onNext: { viewModel.goToNextQuestion() }))
                case 23:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٢٤", content: Question24(onNext: { viewModel.goToNextQuestion() }))
                case 25:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٢٦", content: Question26(onNext: { viewModel.goToNextQuestion() }))
                case 26:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٢٧", content: Question27(answers: ["", "طيارة", "سيارة", "دراجة"], onNext: { viewModel.goToNextQuestion() }))
                case 27:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٢٨", content: Question28(onNext: { viewModel.goToNextQuestion() }))
                case 29:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٣٠", content: Question30(onNext: { viewModel.goToNextQuestion() }))
                case 30:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٣١", content: Question31(onNext: { viewModel.goToNextQuestion() }))
                case 33:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٣٤", content: Question34(onNext: { viewModel.goToNextQuestion() }))
                case 35:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٣٦", content: Question36(onNext: { viewModel.goToNextQuestion() }))
                case 36:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٣٧", content: Question37(onNext: { viewModel.goToNextQuestion() }))
                case 37:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٣٨", content: Question38(onNext: { viewModel.goToNextQuestion() }))
                case 39:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٤٠", content: Question40())
                case 40:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٤١", content: Question41(onNext: { viewModel.goToNextQuestion() }))
                case 41:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٤٢", content: Question42(onNext: { viewModel.goToNextQuestion() }))
                case 42:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٤٣", content: Question43(viewModel: viewModel, onNext: { viewModel.goToNextQuestion() }))
                case 44:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٤٥", content: Question45(viewModel: viewModel, onNext: { viewModel.goToNextQuestion() }))
                case 47:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٤٨", content: Question48(onNext: { viewModel.goToNextQuestion() }))
                case 48:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٤٩", content: Question49(viewModel: viewModel, onNext: { viewModel.goToNextQuestion() }))
                case 49:
                    QuestionHostView(viewModel: viewModel, questionNumber: "٥٠", content: Question50(viewModel: viewModel, onNext: { viewModel.goToNextQuestion() }))
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
