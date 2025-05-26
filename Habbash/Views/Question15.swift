import SwiftUI

struct Question15: View {
    @State private var phase: Int = 0 // 0: أزرق، 1: أحمر
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
            Spacer().frame(height: 40) // كان 100، الآن أقل لرفع كل شيء للأعلى
            Text("اهزم التمساحه")
                .font(.custom("BalooBhaijaan2-Medium", size: 26))
                .foregroundColor(.black)
                .padding(.bottom, 12)
            Spacer(minLength: 20) // كان 50
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
            .padding(.top, -20) // رفع النص والصورة للأعلى قليلاً
            Spacer(minLength: 10) // كان 30
            HStack(spacing: 18) {
                ForEach(0..<4) { i in
                    Button(action: {
                        if i == correctIndex {
                            if phase == 1 {
                                onNext()
                            } else {
                                phase = 1
                            }
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
            Spacer()
        }
        .onAppear {
            phase = 0
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}
 
#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "١٥",
        content: Question15(onNext: {})
    )
}
