import SwiftUI

struct Question38: View {
    @State private var pencilState: PencilState = .unsharpened
    @State private var pencilOffset: CGSize = .zero
    @State private var pinOffset: CGSize = .zero
    @State private var sharpenerOffset: CGSize = .zero
    @State private var showBalloon: Bool = true
    @State private var showPop: Bool = false
    enum PencilState {
        case unsharpened, sharpened
    }
    let sharpenerPos = CGPoint(x: 90, y: 300)
    let pencilPos = CGPoint(x: 200, y: 350)
    let pinPos = CGPoint(x: 320, y: 300)
    let balloonPos = CGPoint(x: 200, y: 150)
    let balloonSize = CGSize(width: 200, height: 300)
    var onNext: () -> Void = {}
    var body: some View {
        ZStack {
            if showBalloon {
                Image("BALLOON")
                    .resizable()
                    .frame(width: balloonSize.width, height: balloonSize.height)
                    .position(balloonPos)
            } else if showPop {
                Image(systemName: "burst.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.red)
                    .position(balloonPos)
                Color.clear
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            onNext()
                        }
                    }
            }
            DraggableItem(
                imageName: "SHARPENER",
                size: CGSize(width: 131, height: 131),
                offset: $sharpenerOffset,
                basePosition: sharpenerPos,
                onDrop: { _ in
                    withAnimation { sharpenerOffset = .zero }
                }
            )
            if pencilState == .unsharpened {
                DraggableItem(
                    imageName: "UNSHARPENED.PENCIL",
                    size: CGSize(width: 150, height: 150),
                    offset: $pencilOffset,
                    basePosition: pencilPos,
                    onDrop: { _ in
                        let pencilCenter = CGPoint(x: pencilPos.x + pencilOffset.width, y: pencilPos.y + pencilOffset.height)
                        let sharpenerRect = CGRect(
                            x: sharpenerPos.x - 131/2,
                            y: sharpenerPos.y - 131/2,
                            width: 131,
                            height: 131
                        )
                        if sharpenerRect.contains(pencilCenter) {
                            withAnimation {
                                pencilState = .sharpened
                                pencilOffset = .zero
                            }
                        } else {
                            withAnimation {
                                pencilOffset = .zero
                            }
                        }
                    }
                )
            } else {
                DraggableItem(
                    imageName: "SHARP.PENCIL",
                    size: CGSize(width: 150, height: 150),
                    offset: $pencilOffset,
                    basePosition: pencilPos,
                    onDrop: { _ in
                        let pencilCenter = CGPoint(x: pencilPos.x + pencilOffset.width, y: pencilPos.y + pencilOffset.height)
                        let balloonRect = CGRect(
                            x: balloonPos.x - balloonSize.width/2,
                            y: balloonPos.y - balloonSize.height/2,
                            width: balloonSize.width,
                            height: balloonSize.height
                        )
                        if balloonRect.contains(pencilCenter) {
                            withAnimation {
                                showBalloon = false
                                showPop = true
                                pencilOffset = .zero
                            }
                        } else {
                            withAnimation {
                                pencilOffset = .zero
                            }
                        }
                    }
                )
            }
            DraggableItem(
                imageName: "PIN",
                size: CGSize(width: 91, height: 137),
                offset: $pinOffset,
                basePosition: pinPos,
                onDrop: { _ in
                    withAnimation { pinOffset = .zero }
                }
            )
        }
        .coordinateSpace(name: "global")
    }
}

struct DraggableItem: View {
    let imageName: String
    let size: CGSize
    @Binding var offset: CGSize
    var basePosition: CGPoint? = nil
    var onDrop: (CGPoint) -> Void
    @GestureState private var dragState = CGSize.zero
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: size.width, height: size.height)
            .position(basePosition ?? .zero)
            .offset(offset)
            .gesture(
                DragGesture()
                    .updating($dragState) { value, state, _ in
                        state = value.translation
                    }
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        let dropLocation = value.location
                        onDrop(dropLocation)
                    }
            )
    }
}

#Preview {
    QuestionHostView(
        viewModel: GameViewModel(),
        questionNumber: "٣٨",
        content: Question38(onNext: {})
    )
}
