import SwiftUI

struct CongratsView: View {
    var onStartOver: () -> Void
    var body: some View {
        ZStack {
            Color(hex: "#F8B933").ignoresSafeArea()
            ConfettiView()
            VStack(spacing: 40) {
                Spacer()
                    .padding(.top, 200)
                Text("مبروك كسرت خشم هبّاش")
                    .font(.custom("BalooBhaijaan2-Medium", size: 36))
                    .foregroundColor(Color(hex: "#83300E"))
                    .multilineTextAlignment(.center)
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                Button(action: onStartOver) {
                    Text("ازهلني")
                        .font(.custom("BalooBhaijaan2-Medium", size: 28))
                        .foregroundColor(Color(hex: "#83300E"))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Color.yellow)
                        .cornerRadius(29)
                }
                Spacer()
                Image("habbashcrop")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 400)
                Spacer()
            }
        }
    }
}

#Preview {
    CongratsView(onStartOver: {})
} 
