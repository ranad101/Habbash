import SwiftUI

struct ChoiceScreen: View {
    var onOption1: () -> Void
    var onOption2: () -> Void
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea(.all, edges: .all)
                if horizontalSizeClass == .regular || geometry.size.width > geometry.size.height {
                    // Landscape: show the interactive screen
                    Image("choice_screenshot")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea(.all, edges: .all)
                        .position(x: geometry.size.width / 1.999, y: geometry.size.height / 2)

                    // Overlay two transparent buttons at the lower choices
                    Button(action: onOption1) {
                        Color.clear
                    }
                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.17)
                    .position(x: geometry.size.width * 0.72, y: geometry.size.height * 0.86)

                    Button(action: onOption2) {
                        Color.clear
                    }
                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.17)
                    .position(x: geometry.size.width * 0.28, y: geometry.size.height * 0.86)
                } else {
                    // Portrait: show a prompt
                    Color.black.opacity(0.7).ignoresSafeArea()
                    Text("بالله اقلب جوالك")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(16)
                }
            }
        }
    }
}

#Preview {
    ChoiceScreen(onOption1: {}, onOption2: {})
} 
