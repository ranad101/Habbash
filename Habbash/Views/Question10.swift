import SwiftUI

struct Question10: View {
    var onNext: () -> Void

    // تقسيم الرسالة إلى ثلاثة صفوف
    let row1: [Character] = Array("اضغط زر")
    let row2: [Character] = Array("البيت")
    let row3: [Character] = Array("للفوز")
    let colors: [Color] = [
        Color(red: 0.98, green: 0.68, blue: 0.33), // برتقالي
        Color(red: 0.99, green: 0.89, blue: 0.38), // أصفر
        Color(red: 0.38, green: 0.29, blue: 0.87), // بنفسجي
        Color(red: 0.47, green: 0.69, blue: 1.00), // أزرق
        Color(red: 0.44, green: 0.82, blue: 0.51), // أخضر
        Color(red: 0.98, green: 0.47, blue: 0.44)  // أحمر
    ]
    let colorReveals: [[Int]] = [
        [0, 7, 12],                // برتقالي
        [1, 8, 13],                // أصفر
        [2, 9, 14],                // بنفسجي
        [3, 10, 15],               // أزرق
        [4, 11, 16],               // أخضر
        [5, 6, 17]                 // أحمر
    ]
    @State private var pressingColor: Int? = nil

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer(minLength: 40)
                VStack(spacing: 12) {
                    rowView(row: row1, offset: 0)
                    rowView(row: row2, offset: row1.count)
                    rowView(row: row3, offset: row1.count + row2.count)
                }
                .padding(.horizontal, 8)
                .environment(\.layoutDirection, .rightToLeft)
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0..<6) { idx in
                        Rectangle()
                            .fill(colors[idx])
                            .frame(width: 50, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        pressingColor = idx
                                    }
                                    .onEnded { _ in
                                        pressingColor = nil
                                    }
                            )
                    }
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                Button(action: {
                    onNext()
                    // Play success voice here
                }) {
                    Color.clear // Red for debugging
                        .frame(width: 60, height: 60)
                }
                .buttonStyle(PlainButtonStyle())
                .position(x: 38, y: -95)
            )
            ZStack {
                VStack {
                    Spacer(minLength: 40)
                    VStack(spacing: 12) {
                        rowView(row: row1, offset: 0)
                        rowView(row: row2, offset: row1.count)
                        rowView(row: row3, offset: row1.count + row2.count)
                    }
                    .padding(.horizontal, 8)
                    .environment(\.layoutDirection, .rightToLeft)
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(0..<6) { idx in
                            Rectangle()
                                .fill(colors[idx])
                                .frame(width: 50, height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in
                                            pressingColor = idx
                                        }
                                        .onEnded { _ in
                                            pressingColor = nil
                                        }
                                )
                        }
                    }
                    .padding(.bottom, 40)
                }
                // Overlay button exactly over the home button
                Button(action: {
                    onNext()
                }) {
                    Color.white.opacity(0.1) // Use red for debugging, change to .clear when done
                        .frame(width: 70, height: 70)
                }
                .buttonStyle(PlainButtonStyle())
                .position(x: 16 + 22, y: -90) // 22 is half of 44
                .zIndex(100) // Ensure it's on top
            }
        }
    }

    // عرض صف من الحروف
    func rowView(row: [Character], offset: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<row.count, id: \.self) { i in
                let globalIndex = offset + i
                if let colorIdx = pressingColor, colorReveals.indices.contains(colorIdx), colorReveals[colorIdx].contains(globalIndex) {
                    Text(String(row[i]))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .frame(width: 32, height: 40)
                        .foregroundColor(colors[colorIdx])
                } else {
                    Text(" ")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .frame(width: 32, height: 40)
                }
            }
        }
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "١٠",
        content: Question10(onNext: {})
    )
}
