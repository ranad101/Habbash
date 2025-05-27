// GameViewModel.swift & ContentView.swift
// Combined for drop‑in integration

import SwiftUI
import SwiftData

// MARK: - Question Model

// MARK: - Game ViewModel
class GameViewModel: ObservableObject {
    enum Screen { case splash, video1, choice, video2, video3, start, question, gameOver, finalVideo }

    @Published var screen: Screen = .splash
    @Published var currentQuestionIndex: Int = 0
    @Published var hearts: Int = 3
    @Published var skips: Int = 3
    @Published var userProgress: UserProgress
    var hasSeenIntroVideos: Bool {
        get { userProgress.hasSeenIntroVideos }
        set { userProgress.hasSeenIntroVideos = newValue; try? modelContext.save() }
    }
    @Environment(\.modelContext) var modelContext

    // Full 50‑step sequence with MCQ placeholders and interactive placeholders
    @Published var questions: [Question] = [
        //  0: Q1 MCQ
        Question(id: 1, questionText: "كيف تبدأ اللعبة ؟", answers: ["زي كذا","بحذر","بروقان","بثقة"], correctAnswerIndex: 0, questionNumber: "١", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        //  1: Q2 MCQ
        Question(id: 2, questionText: "بولقملاب لاؤسلا ةباجا", answers: ["هاه؟","إجابة","بالمقلوب","بيط"], correctAnswerIndex: 3, questionNumber: "٢", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        //  2: Q3 MCQ
        Question(id: 3, questionText: "وش تاسع حرف من الحروف الهجائية", answers: ["هـ","ر","ل","ذ"], correctAnswerIndex: 0, questionNumber: "٣", imageName: nil, questionFontSize: 28, answerFontSizes: [25,25,25,25]),
        //  3: Q4 interactive placeholder
        Question(id: 4, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٤", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        //  4: Q5 interactive placeholder
        Question(id: 5, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٥", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        //  5: Q6 interactive placeholder
        Question(id: 6, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٦", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        //  6: Q7 MCQ
        Question(id: 7, questionText: "اذا فزت بسباق نمل وش بيصير؟", answers: ["الملكة ترسلك شكر رسمي","تصير انت ملك النمل","النمل يقولك يا شطور","تنطرد لانك كثير"], correctAnswerIndex: 2, questionNumber: "٧", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        //  7: Q8 interactive placeholder
        Question(id: 8, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٨", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        //  8: Q9 MCQ
        Question(id: 9, questionText: "النخلة", answers: ["سعف","جذور","رطب","جذع"], correctAnswerIndex: 2, questionNumber: "٩", imageName: "root", questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        //  9: Q10 interactive placeholder
        Question(id: 10, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "١٠", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 10: Q11 MCQ
        Question(id: 11, questionText: "كم عدد الموزات اللي تقدر تاكلها على معده فاضية؟", answers: ["تعتمد على الحجم","ولا وحدة","وحدة","خمسة"], correctAnswerIndex: 2, questionNumber: "١١", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 11: Q12 interactive placeholder
        Question(id: 12, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "١٢", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 12: Q13 interactive placeholder
        Question(id: 13, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "١٣", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 13: Q14 MCQ
        Question(id: 14, questionText: "نتمنى انك كنت مركز لرقم السؤال", answers: ["روح لسؤال ١٧","روح لسؤال ١٥","روح لسؤال ١٤","روح لسؤال ١٦"], correctAnswerIndex: 1, questionNumber: "١٤", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 14: Q15 interactive placeholder
        Question(id: 15, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "١٥", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 15: Q16 MCQ
        Question(id: 16, questionText: "أيهم أثقل ؟ كيلو قطن ولا كيلو حديد", answers: ["كيلو قطن","كيلو حديد","متساويين","خدك"], correctAnswerIndex: 2, questionNumber: "١٦", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 16: Q17 interactive placeholder
        Question(id: 17, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "١٧", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 17: Q18 MCQ
        Question(id: 18, questionText: "اين يمكن ان تجد بيت الشعر؟", answers: ["في ديون المتبني","داخل مشط الحلاق","في الصحراء","فوق السطح"], correctAnswerIndex: 1, questionNumber: "١٨", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 18: Q19 interactive placeholder
        Question(id: 19, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "١٩", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 19: Q20 MCQ
        Question(id: 20, questionText: "الخيار لك فلها 😉", answers: ["١+ تخطي","تجاهل","١+ حياة","-١ حياة"], correctAnswerIndex: 0, questionNumber: "٢٠", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 20: Q21 interactive placeholder
        Question(id: 21, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٢١", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 21: Q22 interactive placeholder
        Question(id: 22, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٢٢", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 22: Q23 MCQ
        Question(id: 23, questionText: "اجابة هذا السؤال كبيرة مره", answers: ["كبيرة مره","راسي","مرة كبيرة","علامة لا نهايه"], correctAnswerIndex: 1, questionNumber: "٢٣", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 23: Q24 interactive placeholder
        Question(id: 24, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٢٤", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 24: Q25 interactive placeholder
        Question(id: 25, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٢٥", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 25: Q26 interactive placeholder
        Question(id: 26, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٢٦", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 26: Q27 interactive placeholder
        Question(id: 27, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٢٧", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 27: Q28 interactive placeholder
        Question(id: 28, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٢٨", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 28: Q29 MCQ
        Question(id: 29, questionText: "وش لون جناح الطيارة؟", answers: ["برتقالي","ماله لون معين","بخير","ابيض"], correctAnswerIndex: 0, questionNumber: "٢٩", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 29: Q30 interactive placeholder
        Question(id: 30, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٣٠", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 30: Q31 interactive placeholder
        Question(id: 31, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٣١", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 31: Q32 MCQ
        Question(id: 32, questionText: "هيبه وتأمر على عشرين رجال وحرمه ؟", answers: ["الصافرة","الحكم","المعلم","الجرس"], correctAnswerIndex: 0, questionNumber: "٣٢", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 32: Q33 MCQ
        Question(id: 33, questionText: "وش تاسع حرف من الحروف الأبجدية", answers: ["هـ","ذ","ر","كأن هذا السوال مر علي🤔"], correctAnswerIndex: 1, questionNumber: "٣٣", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 33: Q34 interactive placeholder
        Question(id: 34, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٣٤", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 34: Q35 MCQ
        Question(id: 35, questionText: "لو حطيت طماطم في البحر وش بيصير لها ؟", answers: ["تروح رحله بحريه","تغرق","تصير عصير","ياكلونها سمك"], correctAnswerIndex: 0, questionNumber: "٣٥", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 35: Q36 interactive placeholder
        Question(id: 36, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٣٦", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 36: Q37 interactive placeholder
        Question(id: 37, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٣٧", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 37: Q38 interactive placeholder
        Question(id: 38, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٣٨", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 38: Q39 MCQ
        Question(id: 39, questionText: "متى يذوب الحديد", answers: ["اذا خاف","اذا انصهر","اذا اشتاق","اذا شافك"], correctAnswerIndex: 1, questionNumber: "٣٩", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 39: Q40 interactive placeholder
        Question(id: 40, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٤٠", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 40: Q41 interactive placeholder
        Question(id: 41, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٤١", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 41: Q42 interactive placeholder
        Question(id: 42, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٤٢", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 42: Q43 interactive placeholder
        Question(id: 43, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٤٣", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 43: Q44 MCQ
        Question(id: 44, questionText: "وش من الخيارات موجود تحت العين", answers: ["ت","رموش","مسافة","خشم"], correctAnswerIndex: 0, questionNumber: "٤٤", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 44: Q45 interactive placeholder
        Question(id: 45, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٤٥", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 45: Q46 MCQ
        Question(id: 46, questionText: "وش يصير إذا انقطع النت", answers: ["تنام بدري","العالم ينهار","يزعل الرواتر","مافي تواصل"], correctAnswerIndex: 0, questionNumber: "٤٦", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 46: Q47 MCQ
        Question(id: 47, questionText: "انتبه ترا اذا قلته بينكسر !", answers: ["المواعين","الصمت","المراية","رقبة الثور"], correctAnswerIndex: 1, questionNumber: "٤٧", imageName: nil, questionFontSize: 28, answerFontSizes: [22,20,18,24]),
        // 47: Q48 interactive placeholder
        Question(id: 48, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٤٨", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 48: Q49 interactive placeholder
        Question(id: 49, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٤٩", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
        // 49: Q50 interactive placeholder
        Question(id: 50, questionText: "", answers: [], correctAnswerIndex: 0, questionNumber: "٥٠", imageName: nil, questionFontSize: nil, answerFontSizes: nil),
    ]

    // Map question indices to interactive SwiftUI views
    private lazy var interactiveBuilders: [Int: (@escaping () -> Void) -> AnyView] = [
        3:  { onNext in AnyView(Question4(onNext: onNext)) },
        4:  { onNext in AnyView(Question5(viewModel: self, onNext: onNext)) },
        5:  { onNext in AnyView(Question6(onNext: onNext)) },
        7:  { onNext in AnyView(Question8(onNext: onNext)) },
        9:  { onNext in AnyView(Question10(onNext: onNext)) },
        11: { onNext in AnyView(Question12(onNext: onNext)) },
        12: { onNext in AnyView(Question13(onNext: onNext)) },
        14: { onNext in AnyView(Question15(onNext: onNext)) },
        16: { onNext in AnyView(Question17(viewModel: self, onNext: onNext)) },
        18: { onNext in AnyView(Question19(onNext: onNext)) },
        20: { onNext in AnyView(Question21(onNext: onNext)) },
        21: { onNext in AnyView(Question22(onNext: onNext)) },
        23: { onNext in AnyView(Question24(didTapHostQuestionNumberAsCorrect: .constant(false), onNext: onNext)) },
        24: { onNext in AnyView(Question25(onNext: onNext)) },
        25: { onNext in AnyView(Question26(onNext: onNext)) },
        26: { onNext in AnyView(Question27(answers: ["القمر","","الشمس","زحل"], onNext: onNext)) },
        27: { onNext in AnyView(Question28(onNext: onNext)) },
        29: { onNext in AnyView(Question30(onNext: onNext)) },
        30: { onNext in AnyView(Question31(onNext: onNext)) },
        32: { onNext in AnyView(Question34(onNext: onNext)) },
        35: { onNext in AnyView(Question36(onNext: onNext)) },
        36: { onNext in AnyView(Question37(onNext: onNext)) },
        37: { onNext in AnyView(Question38(onNext: onNext)) },
        39: { _      in AnyView(Question40()) },
        40: { onNext in AnyView(Question41(onNext: onNext)) },
        41: { onNext in AnyView(Question42(onNext: onNext)) },
        42: { onNext in AnyView(Question43(viewModel: self, onNext: onNext)) },
        44: { onNext in AnyView(Question45(viewModel: self, onNext: onNext)) },
        47: { onNext in AnyView(Question48(onNext: onNext)) },
        48: { onNext in AnyView(Question49(viewModel: self, onNext: onNext)) },
        49: { onNext in AnyView(Question50(onNext: onNext)) }
    ]

    // Return interactive page if exists
    func interactiveView(onNext: @escaping () -> Void) -> AnyView? {
        interactiveBuilders[currentQuestionIndex]?(onNext)
    }

    var currentQuestion: Question? {
        questions.indices.contains(currentQuestionIndex) ? questions[currentQuestionIndex] : nil
    }

    // MARK: - Game control
    func startGame() {
        hearts = 3
        skips = 3
        currentQuestionIndex = 0
        userProgress.currentQuestion = 0
        userProgress.hearts = 3
        userProgress.skips = 3
        try? modelContext.save()
        screen = .question
    }
    func answer(isCorrect: Bool) {
        if isCorrect { next() } else {
            hearts -= 1
            userProgress.hearts = hearts
            try? modelContext.save()
            if hearts == 0 { screen = .gameOver }
        }
    }
    func skip() { if skips>0 {
        skips -= 1
        userProgress.skips = skips
        try? modelContext.save()
        next() } }
    func next() {
        if currentQuestionIndex+1 < questions.count {
            currentQuestionIndex += 1
            userProgress.currentQuestion = currentQuestionIndex
            try? modelContext.save()
            // If we just finished question 50, go to final video
            if currentQuestionIndex == 50 {
                screen = .finalVideo
                return
            }
        }
        else { screen = .gameOver }
    }
    func resetGame() { hearts = 3; skips = 3; currentQuestionIndex = 0; screen = .start }
    // Navigation shortcuts
    func goToSplash() { screen = .splash }
    func goToVideo1() { screen = .video1 }
    func goToChoice() { screen = .choice }
    func goToVideo2() { screen = .video2 }
    func goToVideo3() { screen = .video3 }
    func goToStart() {
        if hasSeenIntroVideos {
            screen = .start
        } else {
            screen = .video1
        }
    }
    func goToFinalVideo() { screen = .finalVideo }

    init(modelContext: ModelContext, userProgress: UserProgress) {
        self.userProgress = userProgress
        self.currentQuestionIndex = userProgress.currentQuestion
        self.hearts = userProgress.hearts
        self.skips = userProgress.skips
    }

    func continueGame() {
        self.hearts = userProgress.hearts
        self.skips = userProgress.skips
        self.currentQuestionIndex = userProgress.currentQuestion
        self.screen = .question
    }
}

