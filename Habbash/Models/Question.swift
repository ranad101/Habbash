import Foundation

struct Question: Identifiable {
    let id: Int
    let questionText: String
    let answers: [String]
    let correctAnswerIndex: Int
    let questionNumber: String
    let imageName: String?
    let questionTextSize: CGFloat
    var questionFontSize: CGFloat?
    var answerFontSizes: [CGFloat]?

    init(
        id: Int,
        questionText: String,
        answers: [String],
        correctAnswerIndex: Int,
        questionNumber: String,
        imageName: String? = nil,
        questionTextSize: CGFloat = 27,
        questionFontSize: CGFloat? = nil,
        answerFontSizes: [CGFloat]? = nil
    ) {
        self.id = id
        self.questionText = questionText
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
        self.questionNumber = questionNumber
        self.imageName = imageName
        self.questionTextSize = questionTextSize
        self.questionFontSize = questionFontSize
        self.answerFontSizes = answerFontSizes
    }
}
