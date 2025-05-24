import SwiftUI

struct Question42: View {
    @State private var hourAngle: Double = 0
    @State private var dragStartAngle: Double = 0
    @State private var isCorrect: Bool? = nil
    @State private var isInteractionEnabled: Bool = true
    @State private var showFeedback: Bool = false
    @State private var imageName: String = "red" // صورة البداية
    var onNext: () -> Void = {}

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .padding(.top, 170)
                    .ignoresSafeArea()
                Spacer(minLength: 0)
                // Question text
                Text("ساعدها! ارجع الوقت.")
                    .font(.custom("BalooBhaijaan2-Medium", size: 28))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                // Clock UI
                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 8)
                        .frame(width: 200, height: 200)
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 8, height: 90)
                        .offset(y: -45)
                        .rotationEffect(.degrees(hourAngle))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if isInteractionEnabled {
                                        let vector = CGVector(dx: value.location.x - 100, dy: value.location.y - 100)
                                        let angle = atan2(vector.dy, vector.dx) * 180 / .pi
                                        hourAngle = angle
                                    }
                                }
                                .onEnded { value in
                                    if isInteractionEnabled {
                                        let vector = CGVector(dx: value.location.x - 100, dy: value.location.y - 100)
                                        let angle = atan2(vector.dy, vector.dx) * 180 / .pi
                                        if angle < -80 && angle > -100 {
                                            isCorrect = true
                                            showFeedback = true
                                            isInteractionEnabled = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                onNext()
                                            }
                                        } else {
                                            isCorrect = false
                                            showFeedback = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                showFeedback = false
                                            }
                                        }
                                    }
                                }
                        )
                }
                .padding(.top, 100)
                // Feedback overlay
                if showFeedback {
                    Image(systemName: isCorrect == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 120))
                        .foregroundColor(isCorrect == true ? .green : .red)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Question42()
} 