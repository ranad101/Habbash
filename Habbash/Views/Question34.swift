import SwiftUI
import AVFoundation

struct Question34: View {
    @State private var selectedCircles: Set<Int> = []
    @State private var audioPlayer: AVAudioPlayer?
    var onNext: () -> Void = {}

    var body: some View {
        VStack(spacing: -88) {
            Text("كم فتحه بالفروه")
                .font(.custom("BalooBhaijaan2-Medium", size: 32))
                .padding(.top,-70)
            ZStack {
                Image("fro")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.top, 50)
                ForEach(1..<9, id: \.self) { number in
                    numberedCircle(number: number, x: CGFloat(50 * (number % 3 - 1)), y: CGFloat(50 * (number / 3 - 1)))
                }
            }
            .padding()
            HStack(spacing: 10) {
                Button(action: {
                    if let first = selectedCircles.first {
                        selectedCircles.remove(first)
                    }
                }) {
                    Image("minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                Button(action: {
                    if selectedCircles.count < 8 {
                        selectedCircles.insert(selectedCircles.count + 1)
                    }
                }) {
                    Image("plss")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 118, height: 133)
                        .padding(.top, 20)
                        .padding(.horizontal, -10)
                }
            }
            .padding(.top, 20)
            Button(action: {
                checkAnswer()
            }) {
                Image("okay")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 50)
            }
            .padding(.top, 50)
        }
    }

    func numberedCircle(number: Int, x: CGFloat, y: CGFloat) -> some View {
        Button(action: {
            if selectedCircles.contains(number) {
                selectedCircles.remove(number)
            } else {
                selectedCircles.insert(number)
            }
        }) {
            Image("circleSelect")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .opacity(selectedCircles.contains(number) ? 1.0 : 0.5)
        }
        .offset(x: x, y: y)
    }

    func checkAnswer() {
        if selectedCircles.count == 8 {
            playSound(isCorrect: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                onNext()
            }
        } else {
            playSound(isCorrect: false)
        }
    }

    func playSound(isCorrect: Bool) {
        let soundName = isCorrect ? "success" : "failure"
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") {
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
    Question34()
} 