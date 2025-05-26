import SwiftUI

struct Question5: View {
    @State private var showSuccess: Bool = false
    @State private var showFailure: Bool = false
    @State private var isGameOver: Bool = false
    @ObservedObject var viewModel: GameViewModel
    
    var onNext: () -> Void = {}
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Image("Q50.BACKGROUND")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea()
                
                VStack {
                    // Question text
                    Text("مو السؤال الصح لازم تعديل")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    // Hidden cat (tappable area)
                    ZStack {
                        // Hidden cat image (invisible but tappable)
                        Image("corcodail")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .opacity(100) // Almost invisible
                            .onTapGesture {
                                if !isGameOver {
                                    showSuccess = true
                                    SoundPlayer.playSound(named: "success")
                                    viewModel.answer(isCorrect: true)
                                }
                            }
                        
                        // Success effect
                        if showSuccess {
                            Image("HIDDEN.CAT")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .position(x: geometry.size.width * 0.7, y: geometry.size.height * 0.6)
                    
                    Spacer()
                }
                
                // Tappable area for wrong answers
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !isGameOver && !showSuccess {
                            showFailure = true
                            SoundPlayer.playSound(named: "failure")
                            viewModel.answer(isCorrect: false)
                            isGameOver = true
                        }
                    }
            }
        }
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٥",
        content: Question5(viewModel: GameViewModel(), onNext: {})
    )
}

