import SwiftUI

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