import SwiftUI
import AVFoundation

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
    @State private var skipCount: Int = 0
    @State private var audioPlayer: AVAudioPlayer?
    let hiddenNumbers: [HiddenNumber] = [
        HiddenNumber(value: 2, asset: "٢", position: CGPoint(x: 90, y: 50), size: CGSize(width: 70, height: 90)),
        HiddenNumber(value: 5, asset: "٥", position: CGPoint(x: 350, y: 110), size: CGSize(width: 60, height: 65)),
        HiddenNumber(value: 7, asset: "٧", position: CGPoint(x: 70, y: 500), size: CGSize(width: 50, height: 55)),
        HiddenNumber(value: 9, asset: "٩", position: CGPoint(x: 380, y: 530), size: CGSize(width: 40, height: 45))
    ]
    let tapRadius: CGFloat = 40
    
    var onNext: () -> Void = {}
    var body: some View {
        ZStack {
            // Hidden numbers (only show if revealed)
            ForEach(0..<4) { i in
                if revealed[i] {
                    Image(hiddenNumbers[i].asset)
                        .resizable()
                        .frame(width: hiddenNumbers[i].size.width, height: hiddenNumbers[i].size.height)
                        .position(hiddenNumbers[i].position)
                        .transition(.scale)
                }
            }
            VStack(spacing: 0) {
                HStack {
                    Text("الصندوق")
                        .font(.custom("BalooBhaijaan2-Medium", size: 20))
                        .foregroundColor(.black)
                    Text("افتح")
                        .font(.custom("BalooBhaijaan2-Medium", size: 60))
                        .foregroundColor(.black)
                }
                

                // Safe box
                ZStack {
                    Image("SAFEBOX")
                        .resizable()
                        .frame(width: 423, height: 282)
                        
                    // Code display area (tunable position)
                    HStack(spacing: 20) {
                        ForEach(0..<4) { i in
                            Text(arabicDigits[code[i]])
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    .position(x: 212, y: 150)
                }
                .padding(.vertical, 0)

                // Number selectors with custom up/down buttons (always available)
                HStack(spacing: 24) {
                    ForEach(0..<4) { i in
                        VStack(spacing: 0) {
                            Button(action: {
                                code[i] = (code[i] + 1) % 10
                                checkWin()
                            }) {
                                Image("UP.ARROW")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                            Text(arabicDigits[code[i]])
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.black)
                            Button(action: {
                                code[i] = (code[i] + 9) % 10
                                checkWin()
                            }) {
                                Image("DOWN.ARROW")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                        }
                    }
                }
                .padding(.bottom, 99)

                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(.horizontal, 16)
            // Add tap gesture to the ZStack to reveal numbers when tapped
            .contentShape(Rectangle())
            .onTapGesture { location in
                for i in 0..<hiddenNumbers.count {
                    if !revealed[i] {
                        let hidden = hiddenNumbers[i]
                        let dx = location.x - hidden.position.x
                        let dy = location.y - hidden.position.y
                        if dx * dx + dy * dy < tapRadius * tapRadius {
                            revealed[i] = true
                        }
                    }
                }
            }
        }
    }
    
    func checkWin() {
        if code == correctCode {
            showSuccess = true
            playSuccessSound()
            // الانتقال التلقائي بعد نصف ثانية
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                onNext()
            }
        } else {
            showSuccess = false
        }
    }

    func playSuccessSound() {
        if let soundURL = Bundle.main.url(forResource: "success", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٣٦",
        content: Question36(onNext: {})
    )
} 
