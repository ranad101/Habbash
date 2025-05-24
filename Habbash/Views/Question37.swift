import SwiftUI

struct Question37: View {
    @State private var isCorrect = false
    @State private var draggedKeyIndex: Int? = nil
    @State private var keyOffsets: [CGSize] = Array(repeating: .zero, count: 4)
    @State private var showSuccess: Bool = false
    let keys = ["KEY.WRONG.1", "KEY.WRONG.2", "KEY.WRONG.3", "KEY.RIGHT"]
    let keyPositions: [CGPoint] = [
        CGPoint(x: 250, y: 150),
        CGPoint(x: 250, y: 300),
        CGPoint(x: 320, y: 400),
        CGPoint(x: 320, y: 230)
    ]
    let lockWidth: CGFloat = 192.05
    let lockHeight: CGFloat = 228.24
    let lockX: CGFloat = 31 + 192.05/2
    let lockY: CGFloat = 120 + 228.24/2
    var onNext: () -> Void = {}
    var body: some View {
        ZStack {
            // Lock image
            Image("LOCK")
                .resizable()
                .frame(width: lockWidth, height: lockHeight)
                .position(x: lockX, y: lockY)
            // Keys
            ForEach(0..<keys.count, id: \.self) { i in
                Image(keys[i])
                    .resizable()
                    .frame(width: 60, height: 60)
                    .position(keyPositions[i])
                    .offset(keyOffsets[i])
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                keyOffsets[i] = value.translation
                            }
                            .onEnded { value in
                                let dropPoint = CGPoint(x: keyPositions[i].x + value.translation.width, y: keyPositions[i].y + value.translation.height)
                                if i == 3 && abs(dropPoint.x - lockX) < 40 && abs(dropPoint.y - lockY) < 40 {
                                    isCorrect = true
                                    showSuccess = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        onNext()
                                    }
                                } else {
                                    keyOffsets[i] = .zero
                                }
                            }
                    )
            }
            // Success feedback
            if showSuccess {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 120))
                    .foregroundColor(.green)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Question37()
} 