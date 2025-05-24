import SwiftUI

struct Question49: View {
    let klegaCount = 7
    let radius: CGFloat = 110
    let klegaSize: CGFloat = 80
    let handSize: CGFloat = 75
    let centerY: CGFloat = 300
    let centerX: CGFloat = 200
    
    @State private var handIndex: Int = 0
    @State private var isFlashing: Bool = false
    @State private var flashIndex: Int? = nil
    @State private var canTap: Bool = false
    @State private var showSuccess: Bool = false
    @State private var showFeedback: Bool = false
    @State private var cycles: Int = 0
    @State private var timer: Timer? = nil
    var onNext: () -> Void = {}
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    // Question text
                    Text("اويلاو وين الكليجه اللي نبيها")
                        .font(.custom("BalooBhaijaan2-Medium", size: 30))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .position(x: centerX, y: 50)
                    // Klega circle
                    ZStack {
                        ForEach(0..<klegaCount, id: \.self) { i in
                            let angle = Double(i) / Double(klegaCount) * 2 * Double.pi - Double.pi/2
                            let x = centerX + radius * cos(angle)
                            let y = centerY + radius * sin(angle)
                            ZStack {
                                Image("KLEGA")
                                    .resizable()
                                    .frame(width: klegaSize, height: klegaSize)
                                    .background(
                                        (isFlashing && flashIndex == i) ? Color.yellow.opacity(0.6) : Color.clear
                                    )
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        if canTap && flashIndex == i {
                                            showSuccess = true
                                            showFeedback = true
                                            canTap = false
                                            SoundPlayer.playSound(named: "success")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                showFeedback = false
                                                onNext()
                                            }
                                        }
                                    }
                                if showSuccess && flashIndex == i {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.green)
                                }
                            }
                            .position(x: x, y: y)
                        }
                        // Animated hand
                        if !showSuccess {
                            let angle = Double(handIndex) / Double(klegaCount) * 2 * Double.pi - Double.pi/2
                            let handX = centerX + (radius + 80) * cos(angle)
                            let handY = centerY + (radius + 80) * sin(angle)
                            Image("HAND")
                                .resizable()
                                .frame(width: handSize, height: handSize)
                                .scaleEffect(x: -1, y: 1)
                                .rotationEffect(.radians(angle - .pi/2))
                                .position(x: handX, y: handY)
                                .animation(.easeInOut(duration: 0.18), value: handIndex)
                        }
                    }
                    Spacer(minLength: 150)
                }
                // Feedback overlay
                if showFeedback {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 120))
                            .foregroundColor(.green)
                    }
                }
            }
            .onAppear { startHandAnimation() }
            .onDisappear { timer?.invalidate() }
        }
        .ignoresSafeArea()
    }
    
    func startHandAnimation() {
        timer?.invalidate()
        handIndex = 0
        cycles = 0
        isFlashing = false
        flashIndex = nil
        canTap = false
        showSuccess = false
        showFeedback = false
        timer = Timer.scheduledTimer(withTimeInterval: 0.20, repeats: true) { _ in
            if isFlashing {
                // End flash
                isFlashing = false
                canTap = true
                timer?.invalidate()
            } else {
                handIndex = (handIndex + 1) % klegaCount
                if handIndex == 0 {
                    cycles += 1
                }
                if cycles >= 2 && handIndex == 0 && flashIndex == nil {
                    // Pick a random klega to flash
                    let random = Int.random(in: 0..<klegaCount)
                    flashIndex = random
                    isFlashing = true
                    // Flash for 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isFlashing = false
                        canTap = true
                    }
                }
            }
        }
    }
}

#Preview {
    Question49()
} 