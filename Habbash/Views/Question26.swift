import SwiftUI
import AVFoundation
import SwiftData
struct Question26: View {
    @State private var isDropped = false
    @State private var skipCount = 0
    @State private var offset = CGSize.zero
    @State private var pageNumber: String = "٢٦"
    @State private var isDragging = false
    @State private var audioPlayer: AVAudioPlayer?
    var onNext: () -> Void = {}
    
    var body: some View {
        GeometryReader { geo in
            // Drop area variables
            let dropX = geo.size.width / 2 - 42 / 2 - 24 + 80
            let dropY: CGFloat = 20 + 100
            let dropWidth: CGFloat = 60
            let dropHeight: CGFloat = 600
            ZStack {
                // Visualize the drop area for debugging
               
                // Draggable badge is always visible and draggable
                Image("PAGENUMBER")
                    .resizable()
                    .frame(width: 42, height: 42)
                    .overlay(
                        Text("٢٦")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .offset(x: geo.size.width / 2 - 42 / 2 - 24, y: -295)
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                                isDragging = true
                            }
                            .onEnded { value in
                                isDragging = false
                                print("Translation:", value.translation)
                                if value.translation.width > -210 && value.translation.width < -150 &&
                                    value.translation.height > 290 && value.translation.height < 330 {
                                    isDropped = true
                                    playSuccessSound()
                                    offset = .zero // Reset badge position
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        onNext()
                                    }
                                } else {
                                    offset = .zero
                                }
                            }
                    )
                    .zIndex(2)
                VStack(spacing: 32) {
                    Spacer().frame(height: 40)
                    Text("كيف بتحل هذي المعادلة؟")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
                    HStack {
                        Spacer()
                        Text("١٠٠٠٠ +")
                            .font(.custom("BalooBhaijaan2-Medium", size: 32))
                            .foregroundColor(.black)
                        Text(isDropped ? "٢٦٣٣" : "٣٣")
                            .font(.custom("BalooBhaijaan2-Medium", size: 32))
                            .foregroundColor(.black)
                            .padding(8)
                        Text("= ١٢٦٣٣")
                            .font(.custom("BalooBhaijaan2-Medium", size: 32))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 60)
                    Spacer()
                }
            }
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
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
       let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٢٦",
        content: Question26(onNext: {})
    )
    .environment(\.modelContext, context)
}
