import SwiftUI
import SwiftData
struct Question17: View {
    @State private var countdown: Int = 6
    @State private var bombScale: CGFloat = 1.0
    @State private var bombShake: CGFloat = 0.0
    @State private var numberScale: CGFloat = 1.0
    @State private var timer: Timer? = nil
    @State private var showExplosion: Bool = false
    @State private var showLoseText: Bool = false
    @State private var isExploded: Bool = false
    @State private var yellowExplosionScale: CGFloat = 0.1
    @ObservedObject var viewModel: GameViewModel
   
    // Arabic numerals for 6 to 1
    let arabicNumbers = [6: "٦", 5: "٥", 4: "٤", 3: "٣", 2: "٢", 1: "١"]
    var onNext: () -> Void = {}
    
    var body: some View {
        ZStack {
            VStack {
                // Question
                Text("فكر بسرعه !!!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                Spacer().frame(height: 40) // Space between question and bomb
                
                // Bomb and countdown number
                ZStack {
                    if !isExploded {
                        Image("BOMB")
                            .resizable()
                            .frame(width: 350, height: 350)
                            .scaleEffect(bombScale)
                            .offset(x: 30) // Move bomb to the right
                            .animation(.easeInOut(duration: 0.15), value: bombScale)
                            .animation(.easeInOut(duration: 0.08), value: bombShake)
                    }
                    
                    if showExplosion {
                        Image("EXPLOSION") // Make sure to add this image to your assets
                            .resizable()
                            .frame(width: 400, height: 400)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    if let num = arabicNumbers[countdown], !isExploded {
                        Text(num)
                            .font(.system(size: 90, weight: .bold))
                            .foregroundColor(.red)
                            .scaleEffect(numberScale)
                            .frame(width: 80, height: 80, alignment: .center)
                            .offset(y: 45)
                            .animation(.easeInOut(duration: 0.15), value: numberScale)
                    }
                    
                    if showLoseText {
                        ZStack {
                            // Yellow explosion effect
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 300, height: 300)
                                .blur(radius: 20)
                                .scaleEffect(yellowExplosionScale)
                                .opacity(0.8)
                                .animation(.easeOut(duration: 0.5), value: yellowExplosionScale)
                            
                            Text("خسررت")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.red)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .frame(width: 350, height: 350)
                Spacer()
            }
            
            // Arrow and hint at bottom left
            if countdown <= 4 && !isExploded {
                VStack {
                    Spacer()
                    HStack {
                        ZStack {
                            Image("ARROW")
                                .resizable()
                                .frame(width: 70, height: 50)
                                .onTapGesture {
                                    // Correct answer - proceed to next question
                                    viewModel.answer(isCorrect: true)
                                }
                            Text("النحشة")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .offset(x: 1)
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 60)
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            startCountdown()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func startCountdown() {
        timer?.invalidate()
        countdown = 6
        bombScale = 1.0
        bombShake = 0.0
        numberScale = 1.0
        showExplosion = false
        showLoseText = false
        isExploded = false
        yellowExplosionScale = 0.1
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.15)) {
                bombScale = 1.15
                numberScale = 1.2
            }
            withAnimation(.easeInOut(duration: 0.08).delay(0.15)) {
                bombShake = -15
            }
            withAnimation(.easeInOut(duration: 0.08).delay(0.23)) {
                bombShake = 15
            }
            withAnimation(.easeInOut(duration: 0.08).delay(0.31)) {
                bombShake = 0
                bombScale = 1.0
                numberScale = 1.0
            }
            
            if countdown > 1 {
                countdown -= 1
            } else {
                // Time's up - show explosion
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExploded = true
                    showExplosion = true
                }
                
                // Show lose text and yellow explosion after explosion
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showLoseText = true
                        yellowExplosionScale = 1.0
                    }
                }
                
                // Deduct heart and handle game over or retry
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    viewModel.answer(isCorrect: false)
                }
                
                timer?.invalidate()
            }
        }
    }
}
