import SwiftUI
import AVFoundation
import SwiftData
struct Question19: View {
    var onNext: () -> Void

    @State private var skipCount = 0
    @State private var pageNumber = "١٩"
    
    @State private var offset = CGSize.zero
    @State private var isDraggingQuestion = false
    @State private var feedbackIcon: String? = nil
    @State private var feedbackColor: Color = .green
    @State private var audioPlayer: AVAudioPlayer?

    let grid = [
        ["O", "O", "X"],
        ["", "O", ""],
        ["X", "", "X"]
    ]
    
    let cellSize: CGFloat = 70
    let spacing: CGFloat = 20
    let correctCell = (row: 2, col: 1) // الصف الثالث، العمود الثاني (موقع الإجابة الصحيحة)

    var body: some View {
        VStack {
            Text("فوز!")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, -3)

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

                    // الدائرة الزرقاء مع رقم ١٩ (ثابتة في مكانها)
                    ZStack {
                        Image("PAGENUMBER")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                        Text(pageNumber)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .position(x: 340, y: -67) // موقع ثابت كما طلبت
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = value.translation
                                isDraggingQuestion = true
                            }
                            .onEnded { value in
                                isDraggingQuestion = false
                                
                                // مركز الخانة الصحيحة (صف 3 عمود 2)
                                let correctFrame = cellFrame(row: correctCell.row, col: correctCell.col, origin: CGPoint(x: gridOriginX, y: gridOriginY))
                                let correctCenter = CGPoint(x: correctFrame.midX, y: correctFrame.midY)
                                
                                // موقع الدائرة الحالي = موقع البداية + الإزاحة
                                let currentPos = CGPoint(x: 340 + offset.width, y: -67 + offset.height)
                                
                                let threshold: CGFloat = 30
                                
                                if abs(currentPos.x - correctCenter.x) < threshold &&
                                    abs(currentPos.y - correctCenter.y) < threshold {
                                    // ثبت الرقم في مركز الخانة الصحيحة
                                    withAnimation {
                                        offset = CGSize(width: correctCenter.x - 340, height: correctCenter.y + 67)
                                        // ملاحظة: هنا +67 لأنه موقع y ثابت سلبي -67 ، نعدل له ليصير موالياً لموقع الخانة الصحيحة
                                    }
                                    playSound(isCorrect: true)
                                    feedbackIcon = "checkmark.circle.fill"
                                    feedbackColor = .green
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        feedbackIcon = nil
                                        onNext()
                                    }
                                } else {
                                    withAnimation {
                                        offset = .zero
                                    }
                                    playSound(isCorrect: false)
                                    feedbackIcon = "xmark.circle.fill"
                                    feedbackColor = .red
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        feedbackIcon = nil
                                    }
                                }
                            }
                    )
                    
                    // عرض علامة الصح أو الخطأ
                    if let icon = feedbackIcon {
                        ZStack {
                            Image(systemName: icon)
                                .font(.system(size: 150))
                                .foregroundColor(feedbackColor)
                        }
                    }
                }
            }
            .frame(height: 400)
            .padding(.horizontal)
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

    func playSound(isCorrect: Bool) {
        let soundName = isCorrect ? "success" : "failure"
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

#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
       let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    QuestionHostView(
        viewModel: viewModel,
        questionNumber: "١٩",
        content: Question19(onNext: {})
    )
    .environment(\.modelContext, context)
}
