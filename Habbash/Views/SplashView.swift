import SwiftUI
import SwiftData

struct SplashView: View {
    var onFinish: () -> Void
    @State private var scale: CGFloat = 0.9
    @State private var titleScale: CGFloat = 0.7
    @State private var titleOpacity: Double = 0.0
    @ObservedObject var viewModel: GameViewModel
    @State private var tapCount = 0
    @State private var lastTapTime = Date()
    
    var body: some View {
        ZStack {
            Color(hex: "#FFBF00")
            Color(hex: "#FFDA43")
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                ZStack {
                    Image("boxfont")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 90)
                    Text("هبّاش")
                        .font(.custom("BalooBhaijaan2-Medium", size: 64))
                        .foregroundColor(Color(hex: "#83300E"))
                        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                }
                .scaleEffect(titleScale)
                .opacity(titleOpacity)
                .padding(.bottom, 8)
                ZStack {
                    GeometryReader { geometry in
                        Image("habbashcrop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 0.9)
                            .scaleEffect(scale)
                            .offset(x: geometry.size.width * -0.04, y: geometry.size.height * 0.34)
                            .onAppear {
                                print("SplashView appeared")
                                withAnimation(.interpolatingSpring(stiffness: 120, damping: 8).delay(0.1)) {
                                    scale = 1.0
                                }
                                // Animate the title
                                withAnimation(.interpolatingSpring(stiffness: 120, damping: 8)) {
                                    titleScale = 1.0
                                    titleOpacity = 1.0
                                }
                                // Auto-continue after 1.5 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    onFinish()
                                }
                            }
                    }
                }
                .frame(height: 500)
                Spacer(minLength: 0)
            }
        }
        .onTapGesture(count: 1) {
            let now = Date()
            if now.timeIntervalSince(lastTapTime) < 1.0 {
                tapCount += 1
                if tapCount >= 3 {
                    viewModel.isDebugMode = true
                    tapCount = 0
                }
            } else {
                tapCount = 1
            }
            lastTapTime = now
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
    let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    SplashView(onFinish: {}, viewModel: viewModel)
        .environment(\.modelContext, context)
}

