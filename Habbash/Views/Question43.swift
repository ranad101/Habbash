import SwiftUI

struct Question43: View {
    @State private var countdown: Int = 6
    @State private var bombScale: CGFloat = 1.0
    @State private var bombShake: CGFloat = 0.0
    @State private var numberScale: CGFloat = 1.0
    @State private var timer: Timer? = nil
    @State private var showFeedback: Bool = false
    @State private var isCorrect: Bool = false
    // Arabic numerals for 6 to 1
    let arabicNumbers = [6: "٦", 5: "٥", 4: "٤", 3: "٣", 2: "٢", 1: "١"]
    var onNext: () -> Void = {}
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    // Question
                    Text("فكر بسرعه !!!")
                        .font(.custom("BalooBhaijaan2-Medium", size: 32))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                    Spacer().frame(height: 40)
                    // Bomb and countdown number
                    ZStack {
                        Image("BOMB")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .scaleEffect(bombScale)
                            .offset(x: bombShake)
                        if countdown > 0 {
                            Text(arabicNumbers[countdown] ?? "")
                                .font(.custom("BalooBhaijaan2-Medium", size: 60))
                                .foregroundColor(.red)
                                .scaleEffect(numberScale)
                                .animation(.easeInOut, value: numberScale)
                        }
                    }
                    .padding(.top, 40)
                    Spacer()
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
            .onAppear { startCountdown() }
            .onDisappear { timer?.invalidate() }
        }
        .ignoresSafeArea()
    }
    
    func startCountdown() {
        timer?.invalidate()
        countdown = 6
        bombScale = 1.0
        bombShake = 0.0
        numberScale = 1.0
        showFeedback = false
        isCorrect = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 1 {
                countdown -= 1
                withAnimation(.easeInOut(duration: 0.2)) {
                    bombScale = 1.1
                    numberScale = 1.2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        bombScale = 1.0
                        numberScale = 1.0
                    }
                }
            } else {
                countdown = 0
                showFeedback = true
                isCorrect = false
                timer?.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    showFeedback = false
                    onNext()
                }
            }
        }
    }
}

#Preview {
    Question43()
} 