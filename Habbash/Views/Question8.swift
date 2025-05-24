import SwiftUI

struct Question8: View {
    var onNext: () -> Void

    @State private var answerStep = 0
    @State private var showCorrect = false
    @State private var showWrong = false

    // الحروف المطلوبة بالترتيب
    let letters = ["م", "و", "ز"]
    // ترتيب الخيارات: "مثو" - "زكر" - "وبير" - "تين"
    let options: [(first: String, rest: String)] = [
        ("م", "ثو"),
        ("ز", "كر"),
        ("و", "بير"),
        ("ت", "ين")
    ]

    // أماكن الحروف على الموزة
    let letterPositions: [CGSize] = [
        CGSize(width: 20, height: -40),   // م
        CGSize(width: 9, height: 1),      // و
        CGSize(width:-10, height: 40)     // ز
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("ايش هذا ؟")
                .font(.title2)
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
                                            .font(.title3)
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .disabled(showCorrect || showWrong)
                                } else {
                                    Button(action: {
                                        handleOptionTap(options[idx].first)
                                    }) {
                                        Text(options[idx].first)
                                            .font(.title3)
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .disabled(showCorrect || showWrong || answerStep > 2)
                                    Text(options[idx].rest)
                                        .font(.title3)
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
            }
            .padding(.top, 8)

            if showCorrect {
                Text("إجابة صحيحة! ")
                    .foregroundColor(.green)
                    .font(.title2)
                    .padding(.top, 16)
            } else if showWrong {
                Text("إجابة خاطئة!")
                    .foregroundColor(.red)
                    .font(.title3)
                    .padding(.top, 16)
            }

            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: showCorrect)
        .animation(.easeInOut, value: showWrong)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showWrong = false
            answerStep = 0
        }
    }
}

#Preview {
    Question8(onNext: {})
}
