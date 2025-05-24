import SwiftUI
import AVFoundation

struct Question12: View {
    @State private var showClosedCat = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var selectedIndex: Int? = nil
    let answers = [
        "ميو ميو ميو",    // الصحيحة
        "ميو ميو ميو ميو",
        "يميو موي",
        "مياو مياو"
    ]
    let correctIndex = 0
    let questionText = "ايش قالت القطة؟"
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)
            // Cat image (changes after 6 seconds)
            if showClosedCat {
                Image("catCLOSED")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .padding(.bottom, 8)
            } else {
                Image("catOPEN")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .padding(.bottom, 8)
                    .onAppear {
                        playMeow()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            withAnimation {
                                showClosedCat = true
                            }
                        }
                    }
            }
            // Question text
            Text(questionText)
                .font(.custom("BalooBhaijaan2-Medium", size: 22))
                .foregroundColor(.black)
                .padding(.bottom, 24)
            // Answer buttons (2x2 grid)
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    answerButton(index: 0)
                    answerButton(index: 1)
                }
                HStack(spacing: 16) {
                    answerButton(index: 2)
                    answerButton(index: 3)
                }
            }
            Spacer()
        }
    }
    
    func playMeow() {
        if let soundURL = Bundle.main.url(forResource: "meow", withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
    
    func answerButton(index: Int) -> some View {
        Button(action: {
            selectedIndex = index
            if index == correctIndex {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    onNext()
                }
            }
        }) {
            Text(answers[index])
                .font(.custom("BalooBhaijaan2-Medium", size: 20))
                .foregroundColor(.white)
                .padding()
                .background(selectedIndex == index ? (index == correctIndex ? Color.green : Color.red) : Color.blue)
                .cornerRadius(12)
        }
        .disabled(selectedIndex != nil)
    }
}

#Preview {
    Question12(onNext: {})
} 