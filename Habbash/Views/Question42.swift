import SwiftUI
import Combine
import CoreGraphics
import AVFoundation
import SwiftData
struct Question42: View {

    @State private var hourAngle: Double = 0
    @State private var isCorrect: Bool = false
    @State private var hasAttempted: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isInteractionEnabled: Bool = true
    @State private var imageName: String = "red" // صورة البداية
    @State private var audioPlayer: AVAudioPlayer?

    var onNext: () -> Void = {}

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 290, height: 200)
                .padding(.top, 170)
                .ignoresSafeArea()

            VStack {
                Text("ساعدها! ارجع الوقت.")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()

                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))

                    ForEach(0..<12) { hour in
                        Text("\(hour == 0 ? 12 : hour)")
                            .font(.caption2)
                            .foregroundColor(.black)
                            .rotationEffect(.degrees(Double((12 - hour) % 12) * 30))
                            .offset(y: -45)
                            .rotationEffect(.degrees(-Double((12 - hour) % 12) * 30))
                    }

                    Rectangle()
                        .frame(width: 2, height: 40)
                        .offset(y: -20)
                        .foregroundColor(.blue)

                    Rectangle()
                        .frame(width: 3, height: 35)
                        .offset(y: -17)
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(hourAngle))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if isInteractionEnabled {
                                        let center = CGPoint(x: 50, y: 50)
                                        let current = CGPoint(x: value.location.x, y: value.location.y)

                                        let deltaX = current.x - center.x
                                        let deltaY = current.y - center.y

                                        var angle = atan2(deltaY, deltaX) * (180 / .pi)

                                        if angle < 0 {
                                            angle += 360
                                        }

                                        angle = (angle - 90).truncatingRemainder(dividingBy: 360)
                                        if angle < 0 { angle += 360 }

                                        // عكس اتجاه دوران العقرب (يرجع للخلف)
                                        hourAngle = (360 - angle).truncatingRemainder(dividingBy: 360)
                                    }
                                }
                                .onEnded { _ in
                                    if isInteractionEnabled && !hasAttempted {
                                        hasAttempted = true
                                        checkAnswer()
                                        isInteractionEnabled = false
                                    }
                                }
                        )
                        .animation(.easeInOut(duration: 0.2), value: hourAngle)
                }
                .padding(.top, -150)

                if hasAttempted {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.largeTitle)
                            .padding()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    onNext()
                                }
                            }
                    } else {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                            .padding()
                    }
                }

                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(isCorrect ? "نجاح" : "خطأ"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("حسناً")))
        }
    }

    func checkAnswer() {
        let requiredHour = 12

        var normalizedAngle = hourAngle.truncatingRemainder(dividingBy: 360)
        if normalizedAngle < 0 {
            normalizedAngle += 360
        }

        let selectedHour = Int((normalizedAngle / 30).rounded()) % 12
        let selectedHourAdjusted = selectedHour == 0 ? 12 : selectedHour

        let isClose = abs(selectedHourAdjusted - requiredHour) <= 1 || abs(selectedHourAdjusted - requiredHour) >= 11

        if isClose {
            isCorrect = true
            imageName = "go"
            alertMessage = "أحسنت! تم إرجاع الوقت."
            showAlert = true
            playSound(for: true)
        } else {
            isCorrect = false
            alertMessage = "حاول مرة أخرى."
            showAlert = true
            playSound(for: false)
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
        questionNumber: "٤٢",
        content: Question42(onNext: {})
    )
    .environment(\.modelContext, context)
}

