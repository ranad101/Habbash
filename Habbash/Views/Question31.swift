import SwiftUI

struct Question31: View {
    @State private var offset = CGSize.zero
    @State private var isDroppedOverAnimals = false
    @State private var showCheckmark = false
    @State private var soundPlayed = false
    var onNext: () -> Void = {}

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 60) {
                    Spacer(minLength: 0)
                    // Question text with drag
                    HStack(spacing: 4) {
                        Text("السؤال")
                            .font(.custom("BalooBhaijaan2-Medium", size: 24))
                            .multilineTextAlignment(.center)
                            .offset(offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        self.offset = value.translation
                                    }
                                    .onEnded { value in
                                        if value.location.y > 150 && value.location.y < 350 {
                                            isDroppedOverAnimals = true
                                            showCheckmark = true
                                            if !soundPlayed {
                                                SoundPlayer.playSound(named: "success")
                                                soundPlayed = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                    onNext()
                                                }
                                            }
                                        } else {
                                            isDroppedOverAnimals = false
                                            showCheckmark = false
                                            soundPlayed = false
                                        }
                                    }
                            )
                            .foregroundColor(isDroppedOverAnimals ? .green : .black)
                        Text("وين الحيوانات اللي فوق")
                            .font(.custom("BalooBhaijaan2-Medium", size: 24))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)

                    // Animal images
                    HStack(spacing: 15) {
                        Image("animal4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                        Image("animal2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                        Image("animal3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                    }
                    .padding(.top, 20)

                    if showCheckmark {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                            .padding(.top, 20)
                    }

                    Spacer(minLength: 60)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Question31()
} 