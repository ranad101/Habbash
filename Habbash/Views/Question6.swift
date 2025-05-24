import SwiftUI

struct Question6: View {
    @State private var offset1: CGSize = .zero
    @State private var offset2: CGSize = .zero
    @State private var offset3: CGSize = .zero
    @State private var cupCount: Int = 0
    @State private var showResult: String? = nil
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 40)

            Text("كم عدد الفناجين؟")
                .font(.title2)

            Spacer()

            ZStack {
                // Fixed cups
                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(x: -80, y: -80)

                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(x: 80, y: -80)

                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(y: 40)

                // Draggable cups
                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(offset1)
                    .offset(x: -80, y: -80)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset1 = gesture.translation
                            }
                    )

                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(offset2)
                    .offset(x: 80, y: -80)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset2 = gesture.translation
                            }
                    )

                Image("cup6")
                    .resizable()
                    .frame(width: 119, height: 119)
                    .offset(offset3)
                    .offset(y: 40)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset3 = gesture.translation
                            }
                    )
            }

            Spacer()

            // Count buttons
            HStack(spacing: 20) {
                Button(action: {
                    cupCount += 1
                }) {
                    Image("plus6")
                        .resizable()
                        .frame(width: 42, height: 40)
                }

                Text("\(cupCount)")
                    .font(.largeTitle)

                Button(action: {
                    if cupCount > 0 {
                        cupCount -= 1
                    }
                }) {
                    Image("minus6")
                        .resizable()
                        .frame(width: 42, height: 40)
                }
            }

            // Confirm button
            Button(action: {
                if cupCount == 6 {
                    showResult = "إجابة صحيحة"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onNext()
                    }
                } else {
                    showResult = "إجابة خاطئة ❌"
                }
            }) {
                Image("ok6")
                    .resizable()
                    .frame(width: 100, height: 40)
            }

            // Result
            if let result = showResult {
                Text(result)
                    .font(.title2)
                    .foregroundColor(result.contains("صح") ? .green : .red)
                    .padding()
            }

            Spacer()
        }
    }
}

#Preview {
    Question6(onNext: {})
} 