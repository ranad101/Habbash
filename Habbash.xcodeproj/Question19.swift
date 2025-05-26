import SwiftUI
import AVFoundation

struct Question19View<Content: View>: View {
    @Binding var skipCount: Int
    @Binding var pageNumber: String
    let content: Content
    var onHomeOverride: (() -> Void)? = nil
    let maxSkips = 4

    @State private var showHomeConfirmation = false
    @State private var navigateToStartPage = false
    @State private var audioPlayer: AVAudioPlayer?

    init(skipCount: Binding<Int>, pageNumber: Binding<String>, onHomeOverride: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self._skipCount = skipCount
        self._pageNumber = pageNumber
        self.onHomeOverride = onHomeOverride
        self.content = content()
    }

    var skipBarImageName: String {
        switch skipCount {
        case 0: return "SKIP.BAR.1"
        case 1: return "SKIP.BAR.2"
        case 2: return "SKIP.BAR.3"
        case 3, 4: return "SKIP.BAR.4"
        default: return "SKIP.BAR.1"
        }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    // الهيدر
                    HStack {
                        Button(action: {
                            if let onHomeOverride = onHomeOverride {
                                onHomeOverride()
                            } else {
                                showHomeConfirmation = true
                            }
                        }) {
                            Image("BUTTON.HOME")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .padding(.leading, 24)
                        }
                        Spacer()
                        HStack {
                            ForEach(0..<3) { _ in
                                Image("HEART")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                        .padding(.trailing, 24)
                    }
                    .padding(.top, 55)

                    // المحتوى
                    content
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)

                    Spacer(minLength: 150)

                    // شريط التخطي
                    ZStack {
                        Image(skipBarImageName)
                            .resizable()
                            .frame(width: 216, height: 52)

                        let slotOffsets: [CGFloat] = [87, 29, -20, -80]
                        if skipCount < maxSkips {
                            Button(action: {
                                playSound(named: "skip")
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    if skipCount < maxSkips {
                                        skipCount += 1
                                    }
                                }
                            }) {
                                Image("SKIP.BUTTON")
                                    .resizable()
                                    .frame(width: 56.5, height: 56.5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .offset(x: slotOffsets[skipCount], y: 1)
                        }
                    }
                    .padding(.bottom, 32)
                    .padding(.trailing, -100)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .ignoresSafeArea()
            .alert("ودك ترجع للبيت؟", isPresented: $showHomeConfirmation) {
                Button("لا", role: .cancel) { }
                Button("اي", role: .none) {
                    navigateToStartPage = true
                }
            }
            .navigationDestination(isPresented: $navigateToStartPage) {
                StartScreen()
            }
        }
    }

    func playSound(named soundName: String) {
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        } else {
            print("Sound file \(soundName).wav not found.")
        }
    }
}

struct Question19: View {
    var onNext: () -> Void

    @State private var skipCount = 0
    @State private var pageNumber = "19"
    
    @State private var questionNumberPosition: CGPoint = CGPoint(x: 40, y: 60)
    @State private var feedbackIcon: String? = nil
    @State private var feedbackColor: Color = .green
    @State private var isDraggingQuestion = false
    @State private var audioPlayer: AVAudioPlayer?

    let grid = [
        ["O", "O", "X"],
        ["X", "", "X"],
        ["", "O", ""]
    ]
    let cellSize: CGFloat = 70
    let spacing: CGFloat = 20
    let correctCell = (row: 2, col: 1)

    var body: some View {
        Question19View(skipCount: $skipCount, pageNumber: $pageNumber) {
            VStack {
                Text("فوز!")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 79)

                GeometryReader { geo in
                    let gridOriginX = (geo.size.width - gridWidth()) / 2
                    let gridOriginY = (geo.size.height - gridHeight()) / 2

                    ZStack {
                        // خطوط الشبكة الرمادية
                        ForEach(1..<3) { i in
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: gridWidth(), height: 3)
                                .position(
                                    x: gridOriginX + gridWidth() / 2,
                                    y: gridOriginY + CGFloat(i) * (cellSize + spacing) - spacing / 2
                                )
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: 3, height: gridHeight())
                                .position(
                                    x: gridOriginX + CGFloat(i) * (cellSize + spacing) - spacing / 2,
                                    y: gridOriginY + gridHeight() / 2
                                )
                        }

                        // الشبكة والرموز
                        VStack(spacing: spacing) {
                            ForEach(0..<3) { row in
                                HStack(spacing: spacing) {
                                    ForEach(0..<3) { col in
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.clear)
                                                .frame(width: cellSize, height: cellSize)

                                            if grid[row][col] == "O" {
                                                Circle()
                                                    .stroke(Color.cyan, lineWidth: 3)
                                                    .frame(width: 50, height: 50)
                                            } else if grid[row][col] == "X" {
                                                XShape()
                                                    .stroke(Color.blue, lineWidth: 4)
                                                    .frame(width: 50, height: 50)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)

                        // الصورة مع الرقم داخل ZStack للسحب
                        ZStack {
                            Image("PAGENUMBER")
                                .resizable()
                                .scaledToFit()
                                .padding(.top, -140)
                                .frame(width: 42, height: 42)
                            Text("٢٢")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.top, -127)
                            Text(pageNumber)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .position(questionNumberPosition)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    questionNumberPosition = value.location
                                    isDraggingQuestion = true
                                }
                                .onEnded { value in
                                    questionNumberPosition = value.location
                                    let gridOrigin = CGPoint(x: gridOriginX, y: gridOriginY)
                                    checkDropPosition(origin: gridOrigin)
                                    isDraggingQuestion = false
                                }
                        )

                        // علامة صح أو خطأ تظهر فوق الشبكة
                        if let icon = feedbackIcon {
                            ZStack {
                                Color.black.opacity(0.3).ignoresSafeArea()
                                Image(systemName: icon)
                                    .font(.system(size: 200))
                                    .foregroundColor(feedbackColor)
                            }
                        }
                    }
                }
                .frame(height: 400)
                .padding(.horizontal)
            }
        }
    }

    func gridWidth() -> CGFloat {
        (cellSize * 3) + (spacing * 2)
    }

    func gridHeight() -> CGFloat {
        (cellSize * 3) + (spacing * 2)
    }

    func cellFrame(row: Int, col: Int, origin: CGPoint) -> CGRect {
        let x = origin.x + CGFloat(col) * (cellSize + spacing)
        let y = origin.y + CGFloat(row) * (cellSize + spacing)
        return CGRect(x: x, y: y, width: cellSize, height: cellSize)
    }

    func checkDropPosition(origin: CGPoint) {
        let threshold: CGFloat = 30
        for row in 0..<3 {
            for col in 0..<3 {
                let frame = cellFrame(row: row, col: col, origin: origin)
                let cellCenter = CGPoint(x: frame.midX, y: frame.midY)
                if abs(questionNumberPosition.x - cellCenter.x) < threshold &&
                   abs(questionNumberPosition.y - cellCenter.y) < threshold {

                    questionNumberPosition = CGPoint(x: cellCenter.x, y: cellCenter.y)

                    if row == correctCell.row && col == correctCell.col {
                        feedbackIcon = "checkmark.circle.fill"
                        feedbackColor = .green
                        playSound(isCorrect: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            feedbackIcon = nil
                            onNext()
                        }
                    } else {
                        feedbackIcon = "xmark.circle.fill"
                        feedbackColor = .red
                        playSound(isCorrect: false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            feedbackIcon = nil
                        }
                    }
                    return
                }
            }
        }
        feedbackIcon = nil
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
        } else {
            print("Sound file \(soundName).wav not found.")
        }
    }
}

// شكل X مخصص
struct XShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        return path
    }
}

// شاشة البداية
struct StartScreen: View {
    var body: some View {
        Text("شاشة البداية")
            .font(.largeTitle)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
    }
}

// إدارة عرض الأسئلة والتنقل
struct QuizView: View {
    @State private var currentQuestion: Int = 19

    var body: some View {
        switch currentQuestion {
        case 19:
            Question19(onNext: {
                // هنا يمكن إضافة منطق الانتقال للسؤال التالي
            })
        default:
            EmptyView()
        }
    }
}

struct Question19_Previews: PreviewProvider {
    static var previews: some View {
        Question19(onNext: {})
    }
} 