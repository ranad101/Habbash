import SwiftUI
import SwiftData
struct Question21: View {
    @State private var droppedIndex: Int? = nil
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var camelFrames: [CGRect] = Array(repeating: .zero, count: 4)
    @State private var camelImages: [String] = ["camel1", "camel2", "camel3", "camel4"]
    @State private var wordFrame: CGRect = .zero
    @State private var hasAnswered = false
    var onNext: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("وين؟")
                    .font(.custom("BalooBhaijaan2-Medium", size: 24))
                    .foregroundColor(.black)
                DraggableWord(
                    dragOffset: $dragOffset,
                    isDragging: $isDragging,
                    droppedIndex: $droppedIndex,
                    camelFrames: $camelFrames,
                    camelImages: $camelImages,
                    wordFrame: $wordFrame,
                    hasAnswered: $hasAnswered,
                    onNext: onNext
                )
                Text(" من بين المجاهيم")
                    .font(.custom("BalooBhaijaan2-Medium", size: 24))
                    .foregroundColor(.black)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            CamelsGrid(
                droppedIndex: $droppedIndex,
                camelFrames: $camelFrames,
                camelImages: $camelImages
            )
            .frame(height: 500)
            Spacer()
        }
    }
}

struct CamelsGrid: View {
    @Binding var droppedIndex: Int?
    @Binding var camelFrames: [CGRect]
    @Binding var camelImages: [String]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    camelView(index: 0, geo: geo)
                    camelView(index: 1, geo: geo)
                }
                HStack(spacing: 12) {
                    camelView(index: 2, geo: geo)
                    camelView(index: 3, geo: geo)
                }
            }
            .padding(.top, -30) // رفع الجملات للأعلى قليلاً
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    func camelView(index: Int, geo: GeometryProxy) -> some View {
        GeometryReader { camelGeo in
            Image(camelImages[index])
                .resizable()
                .frame(width: 150, height: 200)
                .offset(
                    x: (index == 0 || index == 2) ? 40 : 0,
                    y: (index == 0 || index == 2) ? 50 : 0
                )
                .onAppear {
                    DispatchQueue.main.async {
                        camelFrames[index] = camelGeo.frame(in: .global)
                    }
                }
                .onChange(of: camelGeo.frame(in: .global)) { newFrame in
                    DispatchQueue.main.async {
                        camelFrames[index] = newFrame
                    }
                }
        }
        .frame(width: 170, height: 150)
    }
}

struct DraggableWord: View {
    @Binding var dragOffset: CGSize
    @Binding var isDragging: Bool
    @Binding var droppedIndex: Int?
    @Binding var camelFrames: [CGRect]
    @Binding var camelImages: [String]
    @Binding var wordFrame: CGRect
    @Binding var hasAnswered: Bool
    var onNext: () -> Void = {}

    var body: some View {
        Text("الوضحى")
            .font(.custom("BalooBhaijaan2-Medium", size: 24))
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isDragging ? Color.white.opacity(0.2) : Color.clear)
            )
            .offset(dragOffset)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.async {
                                wordFrame = geo.frame(in: .global)
                            }
                        }
                        .onChange(of: dragOffset) { _ in
                            DispatchQueue.main.async {
                                wordFrame = geo.frame(in: .global)
                            }
                        }
                }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !hasAnswered else { return }
                        dragOffset = value.translation
                        isDragging = true
                    }
                    .onEnded { value in
                        guard !hasAnswered else { return }
                        isDragging = false
                        let wordCenter = CGPoint(
                            x: wordFrame.midX + dragOffset.width,
                            y: wordFrame.midY + dragOffset.height
                        )
                        for (i, frame) in camelFrames.enumerated() {
                            if frame.contains(wordCenter) {
                                droppedIndex = i
                                camelImages[i] = "whitecamel"
                                hasAnswered = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    onNext()
                                }
                                break
                            }
                        }
                        dragOffset = .zero
                    }
            )
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
       let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٢١",
        content: Question21(onNext: {})
    )
    .environment(\.modelContext, context)
}
