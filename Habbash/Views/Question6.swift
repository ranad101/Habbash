import SwiftUI
import SwiftData

struct Question6: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var offset1: CGSize = .zero
    @State private var offset2: CGSize = .zero
    @State private var offset3: CGSize = .zero
    @State private var cupCount: Int = 0
    @State private var showResult: String? = nil
    @State private var skipCount: Int = 0
    @State private var pageNumber: String = "٦"
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 40)
            Text("كم عدد الفناجين؟")
                .font(.title2)
            Spacer(minLength: 50)
            ZStack {
                // فناجين ثابتة
                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(x: -80, y: -80)
                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(x: 80, y: -80)
                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(y: 40)
                // فناجين قابلة للسحب
                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(offset1)
                    .offset(x: -80, y: -80)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset1 = gesture.translation
                            }
                    )
                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(offset2)
                    .offset(x: 80, y: -80)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset2 = gesture.translation
                            }
                    )
                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(offset3)
                    .offset(y: 40)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset3 = gesture.translation
                            }
                    )
            }
            // أزرار العدد
            HStack(spacing: 20) {
                Button(action: {
                    cupCount += 1
                }) {
                    Image("plus4")
                        .resizable()
                        .frame(width: 42, height: 40)
                }
                Text("\(cupCount)")
                    .font(.largeTitle)
                Button(action: {
                    if cupCount > 0 {
                        cupCount -= 1
                    }
                }) {
                    Image("minus4")
                        .resizable()
                        .frame(width: 42, height: 40)
                }
            }
            // زر التأكيد
            Button(action: {
                if cupCount == 6 {
                    SoundPlayer.playSound(named: "success")
                    showResult = "إجابة صحيحة"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onNext()
                    }
                } else {
                    SoundPlayer.playSound(named: "failure")
                    showResult = "إجابة خاطئة ❌"
                    viewModel.answer(isCorrect: false)
                }
            }) {
                Image("okay4")
                    .resizable()
                    .frame(width: 130, height: 50)
            }
            // مكان النتيجة ثابت دائماً
            Group {
                if let result = showResult {
                    Text(result)
                        .font(.title2)
                        .foregroundColor(result.contains("صح") ? .green : .red)
                        .frame(height: 48)
                } else {
                    Spacer().frame(height: 48)
                }
            }
            Spacer(minLength: 10)
        }
        .padding()
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
    let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٦",
        content: Question6(viewModel: viewModel, onNext: {})
    )
    .environment(\.modelContext, context)
}
