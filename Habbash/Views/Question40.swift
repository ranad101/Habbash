import SwiftUI

struct Question40: View {
    var onNext: () -> Void = {}
    var body: some View {
    
        VStack(spacing: 32) {
            Spacer(minLength: 60)
            Text("تذكر هذي الاكواد !")
                .font(.custom("BalooBhaijaan2-Medium", size: 28))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            Text("2489")
                .font(.custom("BalooBhaijaan2-Medium", size: 48))
                .foregroundColor(.black)
                .padding(.top, 16)
            Spacer()
        }
        .padding(.top, 0)
    }
}


#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٤٠",
        content: Question40(onNext: {})
    )
}

