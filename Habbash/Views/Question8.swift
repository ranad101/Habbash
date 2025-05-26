import SwiftUI

struct Question8: View {
    @State private var skipCount = 0
    @State private var answerStep = 0
    @State private var showCorrect = false
    @State private var showWrong = false
    @State private var pageNumber: String = "٨"
    var onNext: () -> Void

    let letters = ["م", "و", "ز"]
    let options: [(first: String, rest: String)] = [
        ("م", "ثو"),
        ("ز", "كر"),
        ("و", "بير"),
        ("ت", "ين")
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
                    Image("bannana")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    ForEach(0..<answerStep, id: \.self) { i in
                        Text(letters[i])
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.black)
                            .offset(letterPositions[i])
                    }
                }
                .padding(.leading, 40)

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 18) {
                    ForEach(0..<options.count, id: \.self) { idx in
                        ZStack {
                            Image("BUTTON.REGULAR")
                                .resizable()
                                .frame(width: 140, height: 60)
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
                                        Text(options[idx].first)
                                            .font(.custom("BalooBhaijaan2-Medium", size: 22))
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .allowsHitTesting(!(showCorrect || answerStep > 2))
                                    Text(options[idx].rest)
                                        .font(.custom("BalooBhaijaan2-Medium", size: 22))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                        .frame(height: 60)
                    }
                }
                .padding(.trailing, 70)
                .padding(.leading, -30)
                .offset(x: -20)
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
    }

    func handleOptionTap(_ char: String) {
        let currentLetter = letters[answerStep]
        if char == currentLetter {
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
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٨",
        content: Question8(onNext: {})
    )
}

