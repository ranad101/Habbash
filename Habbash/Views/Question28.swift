import SwiftUI

struct Question28: View {
    @State private var arrowOffset: CGFloat = 0
    @State private var showResult: Bool = false
    @State private var isCorrect: Bool? = nil
    @State private var showArrow: Bool = true
    @State private var showQuestionText: Bool = true
    var onNext: () -> Void = {}

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
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 40)
                    if showQuestionText {
                        Text("اسحب السهم للأعلى!")
                            .font(.custom("BalooBhaijaan2-Medium", size: 24))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                    }
                }
                Spacer()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        arrowOffset = value.translation.height
                    }
                    .onEnded { value in
                        if value.translation.height < -100 {
                            isCorrect = true
                            showResult = true
                            showArrow = false
                            showQuestionText = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                onNext()
                            }
                        } else {
                            isCorrect = false
                            showResult = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                showResult = false
                                arrowOffset = 0
                            }
                        }
                    }
            )
            if showResult {
                Image(systemName: isCorrect == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(isCorrect == true ? .green : .red)
                    .transition(.scale)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Question28()
} 