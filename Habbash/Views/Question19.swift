import SwiftUI
import AVFoundation

struct Question19: View {
    @State private var circlePosition: CGPoint = .zero
    @State private var feedbackIcon: String? = nil
    @State private var feedbackColor: Color = .green
    @State private var questionNumberPosition: CGPoint = CGPoint(x: 40, y: 60)
    @State private var isDraggingQuestion = false
    @State private var audioPlayer: AVAudioPlayer?
    let grid = [
        ["O", "O", "X"],
        ["", "O", ""],
        ["X", "", "X"]
    ]
    let cellSize: CGFloat = 70
    let spacing: CGFloat = 20
    let correctCell = (row: 2, col: 1)
    var onNext: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("فوز!")
                    .font(.custom("BalooBhaijaan2-Medium", size: 26))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                Spacer()
                // Grid
                VStack(spacing: spacing) {
                    ForEach(0..<grid.count, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<grid[row].count, id: \.self) { col in
                                ZStack {
                                    Rectangle()
                                        .stroke(Color.gray, lineWidth: 2)
                                        .frame(width: cellSize, height: cellSize)
                                    if grid[row][col] == "O" {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 40, height: 40)
                                    } else if grid[row][col] == "X" {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.red)
                                            .font(.system(size: 32))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 40)
                Spacer()
            }
            // Draggable question number (removed PAGENUMBER, just keep drag logic if needed)
            // If you want to keep a draggable element, you can use a placeholder or remove this block entirely if not needed.
            // Feedback
            if let icon = feedbackIcon {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(feedbackColor)
                    .position(x: questionNumberPosition.x, y: questionNumberPosition.y)
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
        for row in 0..<3 {
            for col in 0..<3 {
                let frame = cellFrame(row: row, col: col, origin: origin)
                if frame.contains(circlePosition) {
                    let newX = frame.origin.x + (frame.size.width - 42) / 2
                    let newY = frame.origin.y + (frame.size.height - 42) / 2
                    circlePosition = CGPoint(x: newX, y: newY)
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
    Question19(onNext: {})
} 