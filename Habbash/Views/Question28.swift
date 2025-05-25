import SwiftUI

struct Question28: View {
    @State private var arrowOffset: CGFloat = 0
    @State private var showResult: Bool = false
    @State private var isCorrect: Bool? = nil
    @State private var showArrow: Bool = true
    @State private var showQuestionText: Bool = true
    @State private var skipCount: Int = 0
    
    var onNext: () -> Void = {} // أضف هذا المتغير
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                VStack {
                    HStack(spacing: 16) {
                        ZStack {
                            if showArrow {
                                Image("ARROW")
                                    .resizable()
                                    .frame(width: 100, height: 70)
                                    .rotationEffect(.degrees(arrowOffset < 0 ? -10 : 0))
                                    .offset(x: arrowOffset)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                arrowOffset = value.translation.width
                                            }
                                            .onEnded { value in
                                                let offscreen = geometry.size.width + 100
                                                if value.translation.width < -60 {
                                                    // Dragged left: correct
                                                    withAnimation(.spring()) {
                                                        arrowOffset = -offscreen
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        withAnimation {
                                                            showArrow = false
                                                            isCorrect = true
                                                            showResult = true
                                                        }
                                                        // الانتقال التلقائي بعد ثانية
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                            onNext()
                                                        }
                                                    }
                                                } else if value.translation.width > 60 {
                                                    // Dragged right: incorrect
                                                    withAnimation(.spring()) {
                                                        arrowOffset = offscreen
                                                        showQuestionText = false
                                                    }
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        withAnimation {
                                                            showArrow = false
                                                            isCorrect = false
                                                            showResult = true
                                                        }
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                            reset()
                                                        }
                                                    }
                                                } else {
                                                    // Not enough drag, reset
                                                    withAnimation { arrowOffset = 0 }
                                                }
                                            }
                                    )
                            }
                            if showResult, let correct = isCorrect {
                                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(correct ? .green : .red)
                                    .transition(.scale)
                            }
                        }
                        if showQuestionText {
                            Text("لف السهم لليسار")
                                .font(.custom("BalooBhaijaan2-Medium", size: 40))
                                .multilineTextAlignment(.center)
                                .transition(.opacity)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, -8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    
    private func reset() {
        withAnimation {
            arrowOffset = 0
            showResult = false
            isCorrect = nil
            showArrow = true
            showQuestionText = true
        }
    }
    
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٢٨",
        content: Question28(onNext: {})
    )
}

