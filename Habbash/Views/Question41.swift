import SwiftUI
import SwiftData
struct Question41: View {
    @State private var carPosition = CGPoint(x: -10, y: -200)
    @State private var playerOffset = CGPoint(x: 10, y: 140)
    @State private var hasWon = false
    @State private var currentPath = "none"

    // Red Path
    @State private var redUp1 = 0
    @State private var redRight = 0
    @State private var redUp2 = 0

    // Green Path
    @State private var greenRight = 0
    @State private var greenUp = 0
    @State private var greenLeft = 0

    // Orange Path
    @State private var orangeLeft = 0
    @State private var orangeUp = 0
    @State private var orangeRight = 0

    let startPoint = CGPoint(x: 10, y: 140)
    var onNext: () -> Void = {}

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                ZStack {
                    Image("game41")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: geo.size.width * 0.78, height: geo.size.width * 0.78)
                        .padding(.vertical, -20)

                    Image("boysincar")
                        .resizable()
                        .frame(width: 80, height: 60)
                        .offset(x: carPosition.x, y: carPosition.y - 10)

                    if hasWon {
                        VStack(spacing: 8) {
                            Text("مبروك، وصلت للسيارة!")
                                .font(.custom("BalooBhaijaan2-Medium", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green.opacity(0.95))
                                .cornerRadius(16)
                        }
                        .offset(x: carPosition.x, y: carPosition.y - 60)
                        .zIndex(2)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                onNext()
                            }
                        }
                    }

                    Image("boys")
                        .resizable()
                        .frame(width: 40, height: 50)
                        .offset(x: playerOffset.x, y: playerOffset.y - 10)
                        .animation(.easeInOut, value: playerOffset)
                }

                Spacer()

                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        Button(action: {
                            if hasWon { return }

                            if currentPath == "none" && playerOffset == startPoint {
                                currentPath = "red"
                            }

                            if currentPath == "red" {
                                if redUp1 < 2 {
                                    playerOffset.y -= 10
                                    redUp1 += 1
                                } else if redUp1 == 2 && redRight == 13 && redUp2 < 10 {
                                    playerOffset.y -= 10
                                    redUp2 += 1
                                }
                            }

                            if currentPath == "green" {
                                if greenRight == 16 && greenUp < 30 && greenLeft == 0 {
                                    playerOffset.y -= 10
                                    greenUp += 1
                                }
                            }

                            if currentPath == "orange" {
                                if orangeLeft == 18 && orangeUp < 31 && orangeRight == 0 {
                                    playerOffset.y -= 10
                                    orangeUp += 1
                                }
                            }
                        }) {
                            Image("arrowup22")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }
                        Spacer()
                    }

                    HStack {
                        Button(action: {
                            if hasWon { return }

                            if currentPath == "none" && playerOffset == startPoint {
                                currentPath = "orange"
                            }

                            if currentPath == "red" {
                                if redRight > 0 && redUp2 == 0 {
                                    playerOffset.x -= 10
                                    redRight -= 1
                                }
                            }

                            if currentPath == "green" {
                                if greenRight == 16 && greenUp == 30 && greenLeft < 14 {
                                    playerOffset.x -= 10
                                    greenLeft += 1
                                    if greenLeft == 14 {
                                        hasWon = true
                                    }
                                } else if greenRight > 0 && greenUp == 0 && greenLeft == 0 {
                                    playerOffset.x -= 10
                                    greenRight -= 1
                                }
                            }

                            if currentPath == "orange" {
                                if orangeLeft < 18 && orangeUp == 0 && orangeRight == 0 {
                                    playerOffset.x -= 10
                                    orangeLeft += 1
                                } else if orangeUp == 31 && orangeRight > 0 {
                                    playerOffset.x -= 10
                                    orangeRight -= 1
                                }
                            }
                        }) {
                            Image("arrowleft")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }

                        Spacer().frame(width: 48)

                        Button(action: {
                            if hasWon { return }

                            if currentPath == "none" && playerOffset == startPoint {
                                currentPath = "green"
                            }

                            if currentPath == "red" {
                                if redUp1 == 2 && redRight < 13 && redUp2 == 0 {
                                    playerOffset.x += 10
                                    redRight += 1
                                }
                            }

                            if currentPath == "green" {
                                if greenRight < 16 && greenUp == 0 && greenLeft == 0 {
                                    playerOffset.x += 10
                                    greenRight += 1
                                } else if greenRight == 16 && greenUp == 30 && greenLeft > 0 {
                                    playerOffset.x += 10
                                    greenLeft -= 1
                                }
                            }

                            if currentPath == "orange" {
                                if orangeLeft > 0 && orangeUp == 0 && orangeRight == 0 {
                                    playerOffset.x += 10
                                    orangeLeft -= 1
                                } else if orangeUp == 31 && orangeRight < 10 {
                                    playerOffset.x += 10
                                    orangeRight += 1
                                    if orangeRight == 10 {
                                        hasWon = true
                                    }
                                }
                            }
                        }) {
                            Image("arrowright")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            if hasWon { return }

                            if currentPath == "red" {
                                if redUp2 > 0 {
                                    playerOffset.y += 10
                                    redUp2 -= 1
                                } else if redUp1 > 0 && redRight == 0 {
                                    playerOffset.y += 10
                                    redUp1 -= 1
                                }
                            }

                            if currentPath == "green" {
                                if greenUp > 0 && greenLeft == 0 {
                                    playerOffset.y += 10
                                    greenUp -= 1
                                }
                            }

                            if currentPath == "orange" {
                                if orangeLeft == 18 && orangeUp > 0 && orangeRight == 0 {
                                    playerOffset.y += 10
                                    orangeUp -= 1
                                }
                            }
                        }) {
                            Image("arrowdown")
                                .resizable()
                                .frame(width: 45, height: 45)
                        }
                        Spacer()
                    }
                }
                .frame(width: 180)
                .padding(.bottom, 20)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onChange(of: playerOffset) { newValue in
                if newValue == startPoint {
                    resetRed()
                    resetGreen()
                    resetOrange()
                    currentPath = "none"
                }
            }
        }
    }

    func resetAll() {
        playerOffset = CGPoint(x: 10, y: 140)
        hasWon = false
        resetRed()
        resetGreen()
        resetOrange()
        currentPath = "none"
    }

    func resetRed() {
        redUp1 = 0
        redRight = 0
        redUp2 = 0
    }

    func resetGreen() {
        greenRight = 0
        greenUp = 0
        greenLeft = 0
    }

    func resetOrange() {
        orangeLeft = 0
        orangeUp = 0
        orangeRight = 0
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProgress.self, configurations: .init(isStoredInMemoryOnly: true))
    let context = ModelContext(container)
    let userProgress = UserProgress()
       let viewModel = GameViewModel(modelContext: context, userProgress: userProgress)
    QuestionHostView(
        viewModel: viewModel,
        questionNumber: "٤١",
        content: Question41(onNext: {})
    )
    .environment(\.modelContext, context)
}
