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
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    // Question text
                    Text("ساعد الولد يروح الحمام")
                        .font(.custom("BalooBhaijaan2-Medium", size: 32))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, -50)
                        .padding(.top, 40)
                    // Door and skirt interaction
                    ZStack {
                        Image("door")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)
                        Image("rectan")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 10)
                            .padding(.top, -121)
                            .padding(.horizontal, -69)
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
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 120))
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Question48()
} 