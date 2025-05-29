import SwiftUI

struct StartView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showDebugOverlay = false
    
    var body: some View {
        ZStack {
            // ... existing code ...
            
            // Add debug overlay
            if viewModel.isDebugMode {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: { showDebugOverlay.toggle() }) {
                            Image(systemName: "ladybug.fill")
                                .foregroundColor(.red)
                                .font(.title)
                                .padding()
                        }
                    }
                    Spacer()
                }
                
                if showDebugOverlay {
                    VStack(spacing: 20) {
                        Text("Debug Mode")
                            .font(.title)
                            .foregroundColor(.red)
                        
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 10) {
                                ForEach(0..<viewModel.questions.count, id: \.self) { index in
                                    Button(action: {
                                        viewModel.jumpToQuestion(index)
                                        showDebugOverlay = false
                                    }) {
                                        Text("\(index + 1)")
                                            .frame(width: 50, height: 50)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(height: 300)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(15)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
    }
} 