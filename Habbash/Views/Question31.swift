import SwiftUI
import AVFoundation
import SwiftData
struct Question31: View {
    @State private var offset = CGSize.zero
    @State private var isDroppedOverAnimals = false
    @State private var showCheckmark = false
    @State private var soundPlayed = false
    @State private var audioPlayer: AVAudioPlayer?

    var onNext: () -> Void = {}

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 120) {
                HStack() {
                    Text("السؤال")
                        .font(.title2)
                        .foregroundColor(isDroppedOverAnimals ? .green : .black)
                        .offset(offset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // السماح بالحركة أفقياً وعمودياً مع حدود معقولة
                                    let newX = value.translation.width
                                    let newY = value.translation.height

                                    // تقييد الحركة أفقياً داخل عرض الشاشة تقريباً
                                    if abs(newX) < geo.size.width / 2 {
                                        offset = CGSize(width: newX, height: newY)
                                    }
                                }
                                .onEnded { value in
                                    // حساب حدود drop المنطقة فوق الحيوانات (نستخدم قياسات geo)
                                    // الحيوانات تبدأ تقريبا من 30% إلى 55% من ارتفاع الشاشة
                                    let animalsTopY = geo.size.height * 0.3
                                    let animalsBottomY = geo.size.height * 0.55
                                    let droppedY = value.location.y

                                    if droppedY >= animalsTopY && droppedY <= animalsBottomY {
                                        isDroppedOverAnimals = true
                                        showCheckmark = true

                                        if !soundPlayed {
                                            playSound(for: true)
                                            soundPlayed = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                onNext()
                                            }
                                        }

                                        // ضبط مكان النص فوق الحيوانات، مركزي أفقياً، ثابت عمودياً فوقهم
                                        withAnimation {
                                            offset = CGSize(
                                                width: 0,
                                                height: animalsTopY - geo.size.height / 2 + 20
                                            )
                                        }
                                    } else {
                                        isDroppedOverAnimals = false
                                        showCheckmark = false
                                        soundPlayed = false

                                        withAnimation {
                                            offset = .zero
                                        }
                                    }
                                }
                        )
                        .frame(minWidth: 10)

                    Text("وين الحيوانات اللي فوق")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.top, 3)
                        .frame(minWidth: 180)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                HStack(spacing: 20) {
                    Image("animal4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)

                    Image("animal5")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)

                    Image("animal6")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                }
                .frame(maxWidth: .infinity)

                if showCheckmark {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                        .padding(.top, 20)
                }

                Spacer()
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .padding()
        }
    }

    func playSound(for correct: Bool) {
        let soundName = correct ? "success" : "failure"
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        } else {
            print("لم يتم العثور على ملف الصوت \(soundName).wav")
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
        questionNumber: "٣١",
        content: Question31(onNext: {})
    )
    .environment(\.modelContext, context)
}
