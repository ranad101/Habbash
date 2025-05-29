import SwiftUI

struct ConfettiView: View {
    @State private var confetti: [ConfettiPiece] = []
    @State private var scales: [UUID: CGFloat] = [:]
    let colors: [Color] = [.red, .yellow, .green, .blue, .orange, .purple, .pink]
    let shapes: [ConfettiShape] = [.circle, .rectangle, .capsule]
    let count: Int = 40

    var body: some View {
        ZStack {
            ForEach(confetti) { piece in
                ConfettiShapeView(shape: piece.shape)
                    .fill(piece.color)
                    .frame(width: piece.size, height: piece.size)
                    .position(piece.position)
                    .scaleEffect(scales[piece.id] ?? 0.9)
                    .opacity(piece.opacity)
                    .rotationEffect(.degrees(piece.rotation))
                    .animation(.easeOut(duration: 2.0), value: piece.position)
                    .animation(.easeOut(duration: 0.7), value: scales[piece.id])
            }
        }
        .ignoresSafeArea()
        .onAppear {
            let center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            confetti = (0..<count).map { _ in
                ConfettiPiece(
                    id: UUID(),
                    color: colors.randomElement()!,
                    shape: shapes.randomElement()!,
                    size: CGFloat.random(in: 14...26),
                    position: center,
                    opacity: 1.0,
                    rotation: Double.random(in: 0...360),
                    duration: 2.0
                )
            }
            // Animate outward with subtle pop
            for i in confetti.indices {
                let angle = Double.random(in: 0...(2 * .pi))
                let distance = CGFloat.random(in: 120...(UIScreen.main.bounds.height * 0.7))
                let endX = center.x + cos(angle) * distance
                let endY = center.y + sin(angle) * distance
                let id = confetti[i].id
                scales[id] = 0.9
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...0.2)) {
                    withAnimation(.easeOut(duration: 0.7)) {
                        scales[id] = 1.0
                    }
                    withAnimation(.easeOut(duration: 2.0)) {
                        confetti[i].position = CGPoint(x: endX, y: endY)
                        confetti[i].opacity = 0.0
                        confetti[i].rotation += Double.random(in: 90...360)
                    }
                }
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id: UUID
    let color: Color
    let shape: ConfettiShape
    let size: CGFloat
    var position: CGPoint
    var opacity: Double
    var rotation: Double
    let duration: Double
}

enum ConfettiShape {
    case circle, rectangle, capsule
}

struct ConfettiShapeView: Shape {
    let shape: ConfettiShape
    func path(in rect: CGRect) -> Path {
        switch shape {
        case .circle:
            return Circle().path(in: rect)
        case .rectangle:
            return Rectangle().path(in: rect)
        case .capsule:
            return Capsule().path(in: rect)
        }
    }
}

#Preview {
    ConfettiView()
} 