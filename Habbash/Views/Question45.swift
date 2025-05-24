import SwiftUI

struct Question45: View {
    @State private var selected: Int? = nil
    @State private var isCorrect: Bool? = nil
    @State private var showFeedback: Bool = false
    let answers = [
        "خشيم النوم", // Top left
        "وادي بقر",   // Top right
        "مطرفه",      // Bottom left (correct)
        "محير الترمس" // Bottom right
    ]
    let correctIndex = 2
    // Adjustable positions for each answer (relative to geometry size)
    @State private var positions: [CGPoint] = [
        CGPoint(x: 0.28, y: 0.54), // Top left
        CGPoint(x: 0.72, y: 0.54), // Top right
        CGPoint(x: 0.28, y: 0.676), // Bottom left
        CGPoint(x: 0.725, y: 0.676)  // Bottom right
    ]
    // Adjustable background offsets
    let backgroundOffsetX: CGFloat = -1
    let backgroundOffsetY: CGFloat = 50 // Move background 30 points down
    var onNext: () -> Void = {}
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                Image("Q45.BACKGROUND")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .offset(x: backgroundOffsetX, y: backgroundOffsetY)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer()
                    // Answer texts
                    ZStack {
                        ForEach(0..<4) { i in
                            answerText(index: i, fontSize: geo.size.width * 0.09)
                                .position(x: geo.size.width * positions[i].x, y: geo.size.height * positions[i].y)
                                .onTapGesture {
                                    if selected == nil {
                                        selected = i
                                        isCorrect = (i == correctIndex)
                                        showFeedback = true
                                        SoundPlayer.playSound(named: isCorrect == true ? "success" : "failure")
                                        if isCorrect == true {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                showFeedback = false
                                                onNext()
                                            }
                                        } else {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                showFeedback = false
                                                selected = nil
                                                isCorrect = nil
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    Spacer(minLength: 150)
                }
                // Feedback overlay
                if showFeedback {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        Image(systemName: isCorrect == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 120))
                            .foregroundColor(isCorrect == true ? .green : .red)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func answerText(index: Int, fontSize: CGFloat) -> some View {
        Text(answers[index])
            .font(.custom("BalooBhaijaan2-Medium", size: fontSize))
            .foregroundColor(.white)
            .padding(12)
            .background(selected == index ? (isCorrect == true && index == correctIndex ? Color.green : Color.red) : Color.blue)
            .cornerRadius(16)
    }
}

#Preview {
    Question45()
} 