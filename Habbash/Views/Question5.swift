import SwiftUI

struct Question5: View {
    @State private var skipCount = 0
    @State private var selectedAnswer: Int? = nil
    var onNext: () -> Void   // متغير الانتقال للسؤال السادس
    
    var body: some View {
        let answers = ["خارج الخدمة", "خارج الخدمة", "خارج الخدمة", "خارج الخدمة"]
        let questionText = "اضغط على "
        let questionNumber = "٥"
        let correctAnswerIndex = 7 // هذا لن يستخدم فعليًا هنا
        
        VStack(spacing: 16) {
            // "الجواب" هو الزر الصحيح
            Text("الجواب")
                .font(.title2)
                .padding()
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .onTapGesture {
                }}}} // عند الضغط على كلمة الجواب انتقل للسؤال السادس
            #Preview {
        Question5(onNext: {})
    }

