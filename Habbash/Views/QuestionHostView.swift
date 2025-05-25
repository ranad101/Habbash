import SwiftUI

struct QuestionHostView<Content: View>: View {
    @ObservedObject var viewModel: GameViewModel
    let questionNumber: String
    let content: Content

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                // Top bar: Home (left), Hearts (right)
                HStack(alignment: .top) {
                    Button(action: { viewModel.goToStart() }) {
                        Image("BUTTON.HOME")
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                    .padding(.leading, 16)
                    Spacer()
                    HStack(spacing: 4) {
                        ForEach(0..<viewModel.hearts, id: \.self) { _ in
                            Image("HEART")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 8)
                }
                .padding(.top, 24)

                Spacer(minLength: 8)

                // Question number badge (lower, right-aligned)
                Group {
                    HStack {
                        Spacer()
                        Image("PAGENUMBER")
                            .resizable()
                            .frame(width: 42, height: 42)
                            .overlay(
                                Text(questionNumber)
                                    .font(.custom("BalooBhaijaan2-Medium", size: 22))
                                    .foregroundColor(.white)
                            )
                            .padding(.trailing, 24)
                    }
                    .padding(.top, 20)
                }

                // The unique question content
                content

                Spacer()

                // Skip bar at the bottom right
                Group {
                    HStack {
                        Spacer()
                        ZStack {
                            Image(skipBarImageName(for: viewModel.skips))
                                .resizable()
                                .frame(width: 216, height: 52)
                            if viewModel.skips > 0 {
                                Button(action: {
                                    viewModel.skip()
                                }) {
                                    Image("SKIP.BUTTON")
                                        .resizable()
                                        .frame(width: 56.5, height: 56.5)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .offset(x: skipButtonOffset(for: viewModel.skips), y: 1)
                            }
                        }
                        .padding(.trailing, 32)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
    }

    // Helper for skip bar image (reversed so initial has no gray)
    func skipBarImageName(for skips: Int) -> String {
        let maxSkips = 3
        let used = maxSkips - skips
        switch used {
        case 0: return "SKIP.BAR.1"      // no slots grayed
        case 1: return "SKIP.BAR.2"      // 1 slot grayed
        case 2: return "SKIP.BAR.3"      // 2 slots grayed
        case 3: return "SKIP.BAR.4"      // all slots grayed
        default: return "SKIP.BAR.1"
        }
    }

    // Helper for skip button offset (matches your original logic)
    func skipButtonOffset(for skips: Int) -> CGFloat {
        let slotOffsets: [CGFloat] = [-87, -29, 20, 80]
        return skips < slotOffsets.count ? slotOffsets[skips] : 0
    }
}
