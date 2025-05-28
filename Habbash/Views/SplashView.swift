import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void
    @State private var scale: CGFloat = 0.9
    @State private var titleScale: CGFloat = 0.7
    @State private var titleOpacity: Double = 0.0
    
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
                    Text("Habbash")
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
    }
}

// Helper to use hex color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    SplashView(onFinish: {})
}

