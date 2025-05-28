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

struct StarData {
    let x: CGFloat   // 0...1 (fraction of width)
    let y: CGFloat   // 0...1 (fraction of height)
    let size: CGFloat
}

struct StarField: View {
    let stars: [StarData] = [
        .init(x: 0.12, y: 0.18, size: 28),
        .init(x: 0.85, y: 0.22, size: 18),
        .init(x: 0.20, y: 0.80, size: 22),
        .init(x: 0.75, y: 0.75, size: 16),
        .init(x: 0.50, y: 0.10, size: 24),
        .init(x: 0.90, y: 0.60, size: 14),
        .init(x: 0.08, y: 0.60, size: 20),
        .init(x: 0.30, y: 0.40, size: 16),
        .init(x: 0.60, y: 0.85, size: 26),
        .init(x: 0.60, y: 0.30, size: 14)
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<stars.count, id: \.self) { i in
                    let star = stars[i]
                    Image("white.star")
                        .resizable()
                        .frame(width: star.size, height: star.size)
                        .position(
                            x: star.x * geometry.size.width,
                            y: star.y * geometry.size.height
                        )
                        .opacity(0.95)
                        .shadow(color: .white, radius: 12, x: 0, y: 0)
                }
            }
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
                    Image("continue.button")
                        .resizable()
                        .frame(width: 307,height: 301)
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
