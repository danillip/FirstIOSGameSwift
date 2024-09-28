import SwiftUI

struct ContentView: View {
    
    @State private var gradientStart = UnitPoint.topLeading
    @State private var gradientEnd = UnitPoint.bottomTrailing
    @State private var circleAnimation = false
    
    @State private var textPulse = false
    @State private var textColor = Color.white
    
    @State private var isShowingGameView = false
    @State private var isShowingDifficultyThemesView = false
    
    @State private var selectedTheme: String = "Тема 1" // Начальная тема
    @State private var selectedDifficulty: Int = 8 // Начальная сложность (8 пар карт)
    @State private var selectedCardBackground: String = "Фон 1" // Начальный фон
    
    @State private var showingSettings = false
    @AppStorage("isMusicOn") private var isMusicOn = true

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.pink]),
                           startPoint: gradientStart,
                           endPoint: gradientEnd)
            .edgesIgnoringSafeArea(.all)
            .animation(Animation.linear(duration: 5).repeatForever(autoreverses: true))
            .onAppear {
                gradientStart = .bottomTrailing
                gradientEnd = .topLeading
            }
            
            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 200, height: 200)
                .blur(radius: 10)
                .offset(x: circleAnimation ? -150 : 150, y: circleAnimation ? -300 : 300)
                .animation(Animation.easeInOut(duration: 6).repeatForever(autoreverses: true))
            
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 150, height: 150)
                .blur(radius: 20)
                .offset(x: circleAnimation ? 100 : -200, y: circleAnimation ? 300 : -300)
                .animation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true))
            
            VStack(spacing: 20) {
                Text("Игра на память")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .scaleEffect(textPulse ? 1.1 : 1.0)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
                    .onAppear {
                        textPulse = true
                        startColorChange()
                    }
                    .padding()
                
                Button(action: {
                    isShowingGameView = true // Показываем экран игры
                    print("Игра начата!")
                }) {
                    Text("Начать игру")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .fullScreenCover(isPresented: $isShowingGameView) {
                    GameView(selectedTheme: selectedTheme, selectedDifficulty: selectedDifficulty, selectedCardBackground: selectedCardBackground)
                }
                
                Button(action: {
                    isShowingDifficultyThemesView = true
                }) {
                    Text("Сложность/Темы")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.green, Color.orange]), startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .sheet(isPresented: $isShowingDifficultyThemesView) {
                    DifficultyThemesView(selectedTheme: $selectedTheme, selectedDifficulty: $selectedDifficulty, selectedCardBackground: $selectedCardBackground)
                }
                
                Button(action: {
                    showingSettings = true
                }) {
                    Text("Настройки")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView() // Ваше представление настроек
                }
                
                Button(action: {
                    print("Выход из игры!")
                }) {
                    Text("Выйти")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
            }
        }
        .onAppear {
            circleAnimation = true
            
            if isMusicOn {
                SoundPlayerMainMenu.playMusic()
            }
        }
    }
    
    func startColorChange() {
        let colors: [Color] = [.white, .yellow, .green, .blue, .orange, .purple, .red]
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            withAnimation {
                textColor = colors[index]
            }
            index = (index + 1) % colors.count
        }
    }
}

#Preview {
    ContentView()
}
