import SwiftUI

struct AnimatedRaysBackground: View {
    @State private var animate = false
    let rayCount = 16

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let rayLength = sqrt(width * width + height * height)
            ZStack {
                ForEach(0..<rayCount, id: \.self) { i in
                    Capsule()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 6, height: rayLength)
                        .scaleEffect(y: animate ? 1.1 : 0.95, anchor: .center)
                        .opacity(animate ? 0.25 : 0.12)
                        .rotationEffect(.degrees(Double(i) * (360.0 / Double(rayCount))))
                        .animation(
                            .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.05),
                            value: animate
                        )
                }
            }
            .frame(width: width, height: height)
            .onAppear { animate = true }
        }
        .ignoresSafeArea()
    }
}

struct StartPageView: View {
    var isContinue: Bool = false
    var onStart: () -> Void
    var onContinue: () -> Void = {}
    
    @State private var showRestartAlert = false

    var body: some View {
        ZStack {
            Color(hex: "#FFBF00").ignoresSafeArea()
            Color(hex: "#FFDA43").ignoresSafeArea()
            StarField()
            AnimatedRaysBackground()
            VStack(spacing: isContinue ? 24 : 48) {
                Spacer()
                if isContinue {
                    Button(action: { onContinue() }) {
                        Image("continue.button")
                            .resizable()
                            .frame(width: 307,height: 301)
                    }
                    Button(action: { showRestartAlert = true }) {
                        Image("start.small")
                            .resizable()
                            .frame(width: 155,height: 73)
                    }
                    .alert(isPresented: $showRestartAlert) {
                        Alert(
                            title: Text("تأكيد البدء من البداية"),
                            message: Text("هل أنت متأكد أنك تريد البدء من البداية؟"),
                            primaryButton: .destructive(Text("نعم")) { onStart() },
                            secondaryButton: .cancel(Text("لا"))
                        )
                    }
                } else {
                    Image("start.button")
                        .resizable()
                        .frame(width: 307,height: 301)
                        .onTapGesture { onStart() }
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    StartPageView(isContinue: false, onStart: {}, onContinue: {})
    StartPageView(
        isContinue: true,
        onStart: { print("Restart from beginning") },
        onContinue: { print("Continue game") }
    )
}
