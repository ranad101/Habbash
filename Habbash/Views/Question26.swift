import SwiftUI

struct Question26: View {
    @State private var isDropped = false
    @State private var offset = CGSize.zero
    var onNext: () -> Void = {}

    var body: some View {
        VStack(spacing: 32) {
            Spacer().frame(height: 40)
            // Draggable badge (removed PAGENUMBER, just keep drag logic if needed)
            HStack {
                if !isDropped {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 42, height: 42)
                        .offset(offset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.offset = value.translation
                                }
                                .onEnded { value in
                                    // Check if dropped over the number ٣٣ (screen coordinates)
                                    if value.location.y > 180 && value.location.y < 320 &&
                                        value.location.x > 120 && value.location.x < 260 {
                                        isDropped = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            onNext()
                                        }
                                    } else {
                                        offset = .zero
                                    }
                                }
                        )
                        .padding(.leading, 32)
                }
                Spacer()
            }
            .padding(.top, 8)
            // Question text
            Text("اسحب الدائرة للرقم الصحيح")
                .font(.custom("BalooBhaijaan2-Medium", size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
            Spacer()
        }
    }
}

#Preview {
    Question26()
} 