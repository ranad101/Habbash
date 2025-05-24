import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    enum Screen {
        case splash, video1, choice, video2, video3, start, question, gameOver
    }

    @Published var screen: Screen = .splash
    @Published var currentQuestionIndex: Int = 0
    @Published var hearts: Int = 3
    @Published var skips: Int = 3

    // Sample questions (replace with your real data)
    @Published var questions: [Question] = [
        Question(
            id: 1,
            questionText: "كيف تبدأ اللعبة ؟",
            answers: ["زي كذا", "بحذر", "بروقان", "بثقة"],
            correctAnswerIndex: 0,
            questionNumber: "١",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 2,
            questionText: "بولقملاب لاؤسلا ةباجا",
            answers: ["هاه؟", "إجابة", "بالمقلوب", "بيط"],
            correctAnswerIndex: 3,
            questionNumber: "٢",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 3,
            questionText: "وش تاسع حرف من الحروف الهجائية",
            answers: ["هـ", "كان هذا السؤال مر علي 🤔", "ل", "ذ"],
            correctAnswerIndex: 0,
            questionNumber: "٣",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 4,
            questionText: "ناظر زين!!",
            answers: ["", "", "", ""],
            correctAnswerIndex: 3,
            questionNumber: "٤",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        // Question 5 is interactive (Question5 view)
        Question(
            id: 5,
            questionText: "(تفاعلي) سؤال ٥",
            answers: ["", "", "", ""],
            correctAnswerIndex: 0,
            questionNumber: "٥"
        ),
        // Question 6 is interactive (Question6 view)
        Question(
            id: 6,
            questionText: "(تفاعلي) سؤال ٦",
            answers: ["", "", "", ""],
            correctAnswerIndex: 0,
            questionNumber: "٦"
        ),
        Question(
            id: 7,
            questionText: "اذا فزت بسباق نمل وش بيصير؟",
            answers: [
                "الملكة ترسلك شكر رسمي",
                "تصير انت ملك النمل",
                "النمل يقولك يا شطور",
                "تنطرد لانك كثير"
            ],
            correctAnswerIndex: 2,
            questionNumber: "٧",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        // Question 8 is interactive (Question8 view)
        Question(
            id: 8,
            questionText: "(تفاعلي) سؤال ٨",
            answers: ["", "", "", ""],
            correctAnswerIndex: 0,
            questionNumber: "٨"
        ),
        Question(
            id: 9,
            questionText: "النخلة",
            answers: ["سعف", "جذور", "رطب", "جذع"],
            correctAnswerIndex: 2,
            questionNumber: "٩",
            imageName: "root",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        // Question 10 is interactive (Question10 view)
        Question(
            id: 10,
            questionText: "(تفاعلي) سؤال ١٠",
            answers: ["", "", "", ""],
            correctAnswerIndex: 0,
            questionNumber: "١٠"
        )
    ]

    // Add the indices of your interactive questions here (zero-based)
    let interactiveQuestionIndices: Set<Int> = [4, 10, 18] // Example: replace with your real indices
    func isInteractiveQuestion(_ index: Int) -> Bool {
        interactiveQuestionIndices.contains(index)
    }

    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    func startGame() {
        hearts = 3
        skips = 3
        currentQuestionIndex = 0
        screen = .question
    }

    func answer(isCorrect: Bool) {
        if isCorrect {
            goToNextQuestion()
        } else {
            hearts -= 1
            if hearts <= 0 {
                screen = .gameOver
            }
        }
    }

    func skip() {
        if skips > 0 {
            skips -= 1
            goToNextQuestion()
        }
    }

    func goToNextQuestion() {
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
        } else {
            screen = .gameOver
        }
    }

    func resetGame() {
        hearts = 3
        skips = 3
        currentQuestionIndex = 0
        screen = .start
    }

    func goToStart() {
        screen = .start
    }

    func goToSplash() {
        screen = .splash
    }

    func goToVideo1() { screen = .video1 }
    func goToChoice() { screen = .choice }
    func goToVideo2() { screen = .video2 }
    func goToVideo3() { screen = .video3 }
}
