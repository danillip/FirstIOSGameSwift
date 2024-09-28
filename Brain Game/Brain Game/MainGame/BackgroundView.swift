import SwiftUI

struct BackgroundView: View {
    var selectedBackground: String

    var body: some View {
        ZStack {
            switch selectedBackground {
            case "Фон 1":
                AnimatedBackground1()
            case "Фон 2":
                AnimatedBackground2()
            case "Фон 3":
                AnimatedBackground3()
            default:
                Color.white // Базовый фон на случай ошибки
            }
        }
        .ignoresSafeArea()
    }
}

struct AnimatedBackground1: View {
    @State private var startPoint = UnitPoint.top
    @State private var endPoint = UnitPoint.bottom
    @State private var blurAmount: CGFloat = 5.0
    @State private var shapesPosition: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.red, Color.pink, Color.orange]),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .blur(radius: blurAmount)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                        startPoint = .bottom
                        endPoint = .top
                        blurAmount = 10.0
                    }
                }

                Circle()
                    .fill(Color.yellow.opacity(0.7))
                    .frame(width: 100, height: 100)
                    .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.3)
                    .offset(x: shapesPosition.width, y: shapesPosition.height)
                    .blur(radius: blurAmount)

                Rectangle()
                    .fill(Color.green.opacity(0.6))
                    .frame(width: 150, height: 150)
                    .position(x: geometry.size.width * 0.7, y: geometry.size.height * 0.6)
                    .offset(x: -shapesPosition.width, y: -shapesPosition.height)
                    .blur(radius: blurAmount)
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                    shapesPosition = CGSize(width: 100, height: 100)
                }
            }
        }
    }
}

struct AnimatedBackground2: View {
    @State private var startPoint = UnitPoint.top
    @State private var endPoint = UnitPoint.bottom
    @State private var blurAmount: CGFloat = 5.0
    @State private var shapesPosition: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.blue, Color.red]),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .blur(radius: blurAmount)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                        startPoint = .bottom
                        endPoint = .top
                        blurAmount = 10.0
                    }
                }

                Circle()
                    .fill(Color.green.opacity(0.7))
                    .frame(width: 100, height: 100)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.2)
                    .offset(x: shapesPosition.width, y: shapesPosition.height)
                    .blur(radius: blurAmount)

                Rectangle()
                    .fill(Color.blue.opacity(0.6))
                    .frame(width: 120, height: 120)
                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.7)
                    .offset(x: -shapesPosition.width, y: -shapesPosition.height)
                    .blur(radius: blurAmount)
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                    shapesPosition = CGSize(width: 80, height: 80)
                }
            }
        }
    }
}

struct AnimatedBackground3: View {
    @State private var startPoint = UnitPoint.top
    @State private var endPoint = UnitPoint.bottom
    @State private var blurAmount: CGFloat = 5.0
    @State private var shapesPosition: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.red, Color.green]),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .blur(radius: blurAmount)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                        startPoint = .bottom
                        endPoint = .top
                        blurAmount = 10.0
                    }
                }

                Circle()
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 90, height: 90)
                    .position(x: geometry.size.width * 0.4, y: geometry.size.height * 0.4)
                    .offset(x: shapesPosition.width, y: shapesPosition.height)
                    .blur(radius: blurAmount)

                Rectangle()
                    .fill(Color.red.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .position(x: geometry.size.width * 0.6, y: geometry.size.height * 0.8)
                    .offset(x: -shapesPosition.width, y: -shapesPosition.height)
                    .blur(radius: blurAmount)
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                    shapesPosition = CGSize(width: 120, height: 120)
                }
            }
        }
    }
}

#Preview {
    BackgroundView(selectedBackground: "Фон 1")
}
