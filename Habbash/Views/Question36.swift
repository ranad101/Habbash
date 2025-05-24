import SwiftUI

struct HiddenNumber {
    let value: Int
    let asset: String
    let position: CGPoint
    let size: CGSize
}

struct Question36: View {
    @State private var code: [Int] = [0, 0, 0, 0]
    let correctCode = [2, 5, 7, 9]
    let arabicDigits = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
    @State private var revealed: [Bool] = [false, false, false, false]
    @State private var showSuccess: Bool = false
    let hiddenNumbers: [HiddenNumber] = [
        HiddenNumber(value: 2, asset: "٢", position: CGPoint(x: 90, y: 100), size: CGSize(width: 60, height: 80)),
        HiddenNumber(value: 5, asset: "٥", position: CGPoint(x: 350, y: 150), size: CGSize(width: 40, height: 45)),
        HiddenNumber(value: 7, asset: "٧", position: CGPoint(x: 70, y: 550), size: CGSize(width: 30, height: 35)),
        HiddenNumber(value: 9, asset: "٩", position: CGPoint(x: 380, y: 550), size: CGSize(width: 25, height: 30))
    ]
    let tapRadius: CGFloat = 40
    var onNext: () -> Void = {}
    var body: some View {
        ZStack {
            // Hidden numbers
            ForEach(0..<hiddenNumbers.count, id: \.self) { i in
                let number = hiddenNumbers[i]
                if !revealed[i] {
                    Image(number.asset)
                        .resizable()
                        .frame(width: number.size.width, height: number.size.height)
                        .position(number.position)
                        .onTapGesture {
                            revealed[i] = true
                            code[i] = number.value
                            if code == correctCode {
                                showSuccess = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    onNext()
                                }
                            }
                        }
                }
            }
            // Code display
            HStack(spacing: 16) {
                ForEach(0..<4) { i in
                    Text(arabicDigits[code[i]])
                        .font(.custom("BalooBhaijaan2-Medium", size: 40))
                        .frame(width: 50, height: 60)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            .position(x: 240, y: 400)
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
    Question36()
} 