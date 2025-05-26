import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    enum Screen {
        case splash, video1, choice, video2, video3, start, question, gameOver
    }

    @Published var screen: Screen = .question
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
        
        // Question 5 is interactive (Question5 view)
        // Question 6 is interactive (Question6 view)
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
            id: 9,
            questionText: "النخلة",
            answers: ["سعف", "جذور", "رطب", "جذع"],
            correctAnswerIndex: 2,
            questionNumber: "٩",
            imageName: "root",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
       
        Question(
            id: 11,
            questionText: "كم عدد الموزات اللي تقدر تاكلها على معده فاضية؟",
            answers: ["تعتمد على الحجم", "ولا وحدة", "وحدة", "خمسة"],
            correctAnswerIndex: 2,
            questionNumber: "١١",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 14,
            questionText: "نتمنى انك كنت مركز لرقم السؤال",
            answers: ["روح لسؤال ١٧", "روح لسؤال ١٥", "روح لسؤال ١٤", "روح لسؤال ١٦"],
            correctAnswerIndex: 1,
            questionNumber: "?",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 16,
            questionText: "أيهم أثقل ؟ كيلو قطن ولا كيلو حديد",
            answers: ["كيلو قطن", "كيلو حديد", "متساويين", "خدك"],
            correctAnswerIndex: 2,
            questionNumber: "١٦",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 18,
            questionText: "اين يمكن ان تجد بيت الشعر؟",
            answers: ["في ديون المتبني", "داخل مشط الحلاق", "في الصحراء", "فوق السطح"],
            correctAnswerIndex: 1,
            questionNumber: "١٨",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 20,
            questionText: "الخيار لك فلها 😉",
            answers: ["١+ تخطي", "تجاهل", "١+ حياة", "-١ حياة"],
            correctAnswerIndex: 0,
            questionNumber: "٢٠",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 23,
            questionText: "اجابة هذا السؤال كبيرة مره",
            answers: ["كبيرة مره", "راسي", "مرة كبيرة", "علامة لا نهايه"],
            correctAnswerIndex: 1,
            questionNumber: "٢٣",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 29,
            questionText: "وش لون جناح الطيارة؟",
            answers: ["برتقالي", "ماله لون معين", "بخير", "ابيض"],
            correctAnswerIndex: 0,
            questionNumber: "٢٩",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 32,
            questionText: "هيبه وتأمر على عشرين رجال وحرمه ؟",
            answers: ["الصافرة", "الحكم", "المعلم", "الجرس"],
            correctAnswerIndex: 0,
            questionNumber: "٣٢",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 33,
            questionText: "وش تاسع حرف من الحروف الأبجدية",
            answers: ["هـ", "ذ", "ر", "كأن هذا السوال مر علي🤔"],
            correctAnswerIndex: 1,
            questionNumber: "٣٣",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 35,
            questionText: "لو حطيت طماطم في البحر وش بيصير لها ؟",
            answers: ["تروح رحله بحريه", "تغرق", "تصير عصير", "ياكلونها سمك"],
            correctAnswerIndex: 0,
            questionNumber: "٣٥",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 39,
            questionText: "متى يذوب الحديد",
            answers: ["اذا خاف", "اذا انصهر", "اذا اشتاق", "اذا شافك"],
            correctAnswerIndex: 1,
            questionNumber: "٣٩",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 44,
            questionText: "وش من الخيارات موجود تحت العين",
            answers: ["ت", "رموش", "مسافة", "خشم"],
            correctAnswerIndex: 0,
            questionNumber: "٤٤",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 46,
            questionText: "وش يصير إذا انقطع النت",
            answers: ["تنام بدري", "العالم ينهار", "يزعل الرواتر", "مافي تواصل"],
            correctAnswerIndex: 0,
            questionNumber: "٤٦",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
        ),
        Question(
            id: 47,
            questionText: "انتبه ترا اذا قلته بينكسر !",
            answers: ["المواعين", "الصمت", "المراية", "رقبة الثور"],
            correctAnswerIndex: 1,
            questionNumber: "٤٧",
            questionFontSize: 28,
            answerFontSizes: [22, 20, 18, 24]
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
