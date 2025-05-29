import SwiftUI
import SwiftData
struct Question8: View {
    @State private var skipCount = 0
    @State private var answerStep = 0
    @State private var showCorrect = false
    @State private var showWrong = false
    @State private var pageNumber: String = "٨"
    @State private var highlightScale: CGFloat = 1
    var onNext: () -> Void

    let letters = ["ت", "م", "ر"]
    let options: [(first: String, rest: String)] = [
        ("ت", "بسكو"),
        ("ر", "جز"),
        ("م", "برقوق الشا"),
        ("خ", "وخ")
    ]
    let letterPositions: [CGSize] = [
        CGSize(width: 20, height: -40),
        CGSize(width: 9, height: 1),
        CGSize(width:-10, height: 40)
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("ايش هذا ؟")
                .font(.custom("BalooBhaijaan2-Medium", size: 26))
                .foregroundColor(.black)
                .padding(.bottom, 12)

            HStack(alignment: .center, spacing: 0) {
                ZStack {
                    Image("DATES")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    ForEach(0..<answerStep, id: \.self) { i in
                        Text(letters[i])
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.black)
                            .scaleEffect(highlightScale)
                            .offset(letterPositions[i])
                            .animation(.easeInOut(duration: 0.3), value: highlightScale)
                    }
                }
                .padding(.leading, 40)
                .offset(x: -25) // <-- هنا التعديل لتحريك التمرة فقط لليسار

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 18) {
                    ForEach(0..<options.count, id: \.self) { idx in
                        ZStack {
                            Image("BUTTON.REGULAR")
                                .resizable()
                                .frame(width: 180, height: 60)
                            HStack(spacing: 0) {
                                if idx == 3 {
                                    Button(action: {
                                        handleWrongTap()
                                    }) {
                                        Text(options[idx].first + options[idx].rest)
                                            .font(.custom("BalooBhaijaan2-Medium", size: 22))
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .allowsHitTesting(!showCorrect)
                                } else {
                                    Button(action: {
                                        handleOptionTap(options[idx].first)
                                    }) {
                                        HStack(spacing: 0) {
                                            Text(options[idx].first)
                                                .font(.custom("BalooBhaijaan2-Medium", size: 22))
                                                .foregroundColor(.white)
                                                .scaleEffect(highlightScale)
                                                .animation(.easeInOut(duration: 0.3), value: highlightScale)
                                            Text(options[idx].rest)
                                                .font(.custom("BalooBhaijaan2-Medium", size: 22))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .allowsHitTesting(!(showCorrect || answerStep > 2))
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                        .frame(height: 60)
                    }
                }
                .padding(.trailing, 70)
                .padding(.leading, -30)
                .offset(x: -40)
            }
            .padding(.top, 8)

            Group {
                if showCorrect {
                    Text("إجابة صحيحة! ")
                        .foregroundColor(.green)
                        .font(.title2)
                        .padding(.top, 16)
                        .frame(height: 38)
                } else if showWrong {
                    Text("إجابة خاطئة!")
                        .foregroundColor(.red)
                        .font(.title3)
                        .padding(.top, 16)
                        .frame(height: 38)
                } else {
                    Spacer().frame(height: 38)
                }
            }

            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    highlightScale = 1.25
                }
            }
        }
    }

    func handleOptionTap(_ char: String) {
        let currentLetter = letters[answerStep]
        if char == currentLetter || (answerStep == 0 && char == "ة" && currentLetter == "ت") {
            if answerStep == 2 {
                showCorrect = true
                answerStep += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    onNext()
                }
            } else {
                answerStep += 1
            }
        } else {
            handleWrongTap()
        }
    }

    func handleWrongTap() {
        showWrong = true
        answerStep = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showWrong = false
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
       let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٨",
        content: Question8(onNext: {})
    )
    .environment(\.modelContext, context)
}
