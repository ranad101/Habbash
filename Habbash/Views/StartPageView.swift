import SwiftUI

struct StartPageView: View {
    var isContinue: Bool = false
    var onStart: () -> Void
    var onContinue: () -> Void = {}
    
    @State private var showRestartAlert = false

    var body: some View {
        ZStack {
            Color(hex: "#FFDA43").ignoresSafeArea()
            VStack(spacing: isContinue ? 24 : 48) {
                Spacer()
                if isContinue {
                    // Continue scenario
                    Image("continue.button")
                        .resizable()
                        .frame(width: 307,height: 301)
                    Button(action: { showRestartAlert = true }) {
                        Image("start.small")
                            .resizable()
                            .frame(width: 155,height: 73)
                    }
                    .alert(isPresented: $showRestartAlert) {
                        Alert(
                            title: Text("تأكيد البدء من البداية"),
                            message: Text("هل أنت متأكد أنك تريد البدء من البداية؟"),
                            primaryButton: .destructive(Text("نعم")) { onStart() },
                            secondaryButton: .cancel(Text("لا"))
                        )
                    }
                } else {
                    // First start scenario
                    Image("start.button")
                        .resizable()
                        .frame(width: 307,height: 301)
                        .onTapGesture { onStart() }
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
     StartPageView(isContinue: true, onStart: {}, onContinue: {})
 }
