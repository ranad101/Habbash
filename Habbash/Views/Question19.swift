

import SwiftUI
import AVFoundation

struct Question19: View {
    @State private var showClosedCat = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var skipCount = 0
    @State private var selectedIndex: Int? = nil
    
    let correctIndex = 0
    let questionText = ""
    let questionNumber = 12
    var onNext: () -> Void   // أضف هذا المتغير
    
    var body: some View {
        
        VStack(spacing: 0) {
            Spacer().frame(height: 40)
            
            // صورة القطة (تتغير بعد 6 ثوانٍ)
            if showClosedCat {
                Image("")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .padding(.bottom, 8)
            } else {
                Image("")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .padding(.bottom, 8)
                    .onAppear {
                        playMeow()
                        // بعد 6 ثوانٍ تتغير الصورة
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            withAnimation {
                                showClosedCat = true
                            }
                        }
                    }
            }
            
            // نص السؤال
            Text(questionText)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.black)
                .padding(.bottom, 24)
          
            .padding(.horizontal, 16)
            
            Spacer()
        }
    }
    
    
 
    
    // تشغيل صوت القطة مرة واحدة فقط
    func playMeow() {
        if let url = Bundle.main.url(forResource: "meowVoice", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("خطأ في تشغيل الصوت")
            }
        } else {
            print("لم يتم العثور على ملف الصوت")
        }
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "١٩",
        content: Question19(onNext: {})
    )
}





