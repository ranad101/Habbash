import SwiftUI

struct Question15: View {
    @State private var phase: Int = 0 // 0: أزرق، 1: أحمر
    @State private var showCorrect = false
    @State private var timer: Timer?
    var onNext: () -> Void

    // ترتيب الدوائر: أخضر - أحمر - أزرق - أصفر
    let colorImages = ["greencircle", "redcircle", "bluecircle", "yellowcircle"]

    var correctIndex: Int {
        // أزرق = 2، أحمر = 1 حسب ترتيب الدوائر
        return phase == 0 ? 2 : 1
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 100)
            Text("اهزم التمساح")
                .font(.custom("BalooBhaijaan2-Medium", size: 26))
                .foregroundColor(.black)
                .padding(.bottom, 12)
            Spacer(minLength: 50)
            HStack(alignment: .center, spacing: 24) {
                if phase == 0 {
                    Text("ازرق")
                        .font(.custom("BalooBhaijaan2-Medium", size: 44))
                        .foregroundColor(.blue)
                } else {
                    Text("احمر")
                        .font(.custom("BalooBhaijaan2-Medium", size: 44))
                        .foregroundColor(.green)
                }
                Image("corcodail")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer(minLength: 30)
            HStack(spacing: 18) {
                ForEach(0..<4) { i in
                    Button(action: {
                        if i == correctIndex {
                            showCorrect = true
                            if phase == 1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    onNext()
                                }
                            }
                        } else {
                            showCorrect = false
                        }
                    }) {
                        Image(colorImages[i])
                            .resizable()
                            .frame(width: 64, height: 64)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top, 8)
            if showCorrect {
                Text("إجابة صحيحة! 🎉")
                    .foregroundColor(.green)
                    .font(.custom("BalooBhaijaan2-Medium", size: 22))
                    .padding(.top, 16)
            }
            Spacer()
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    func startTimer() {
        timer?.invalidate()
        showCorrect = false
        phase = 0
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            withAnimation {
                phase = 1
                showCorrect = false
            }
        }
    }
}

#Preview {
    Question15(onNext: {})
} 