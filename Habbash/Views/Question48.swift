import SwiftUI

struct Question48: View {
    @State private var skirtPosition = CGSize(width: 150, height: 250)
    private let originalPosition = CGSize(width: 150, height: 250)
    @State private var showFeedback: Bool = false
    @State private var isCorrect: Bool = false
    @State private var soundPlayed = false
    var onNext: () -> Void = {}
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack() {
                    Spacer(minLength: 0)
                    // Question text
                    Text("ساعد الولد يروح الحمام")
                        .font(.custom("BalooBhaijaan2-Medium", size: 32))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                        .padding(.top, 10)
                    // Door and skirt interaction
                    ZStack {
                        Image("door")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350)
                        Image("rectan")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 10)
                            .padding(.top, -167)
                            .padding(.horizontal, -55)
                            .position(x: skirtPosition.width, y: skirtPosition.height)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        self.skirtPosition = CGSize(
                                            width: originalPosition.width + value.translation.width,
                                            height: originalPosition.height + value.translation.height
                                        )
                                        let distance = hypot(
                                            skirtPosition.width - originalPosition.width,
                                            skirtPosition.height - originalPosition.height
                                        )
                                        if distance > 50 {
                                            if !soundPlayed {
                                                isCorrect = true
                                                showFeedback = true
                                                SoundPlayer.playSound(named: "success")
                                                soundPlayed = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                    showFeedback = false
                                                    onNext()
                                                }
                                            }
                                        } else {
                                            showFeedback = false
                                            isCorrect = false
                                            soundPlayed = false
                                        }
                                    }
                            )
                    }
                    Spacer(minLength: 150)
                }
                // Feedback overlay
                if showFeedback {
                }
            }
        }
        .ignoresSafeArea()
    }
}
#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٤٩",
        content: Question48(onNext: {})
    )
}
