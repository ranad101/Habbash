import SwiftUI
import SwiftData
struct Question40: View {
    var onNext: () -> Void = {}
    var body: some View {
    
        VStack(spacing: 3) {
            Spacer(minLength: 60)
            Text("تذكر هذي الاكواد !")
                .font(.custom("BalooBhaijaan2-Medium", size: 28))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            Text("2489")
                .font(.custom("BalooBhaijaan2-Medium", size: 48))
                .foregroundColor(.black)
                .padding(.top, 10)
            Spacer()
            Button(action: onNext) {
                Text("طيب")
                    .font(.custom("BalooBhaijaan2-Medium", size: 28))
                    .foregroundColor(.red)
                    
                    
                    
            }
        }
        .padding(.top, 0)
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProgress.self, configurations: config)
    let userProgress = UserProgress()
    container.mainContext.insert(userProgress)
    
    return QuestionHostView(
        viewModel: GameViewModel(modelContext: container.mainContext, userProgress: userProgress),
        questionNumber: "٤٠",
        content: Question40(onNext: {})
    )
}

