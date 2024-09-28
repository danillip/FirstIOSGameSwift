import SwiftUI

struct SettingsView: View {
    @AppStorage("isMusicOn") private var isMusicOn = true  // Используем @AppStorage для сохранения настройки

    var body: some View {
        VStack {
            Text("Настройки")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Toggle(isOn: $isMusicOn) {
                Text("Музыка в главном меню")
                    .font(.title2)
                    .padding()
            }
            .onChange(of: isMusicOn) { value in
                // Включаем или выключаем музыку в зависимости от переключателя
                if value {
                    SoundPlayerMainMenu.playMusic()
                } else {
                    SoundPlayerMainMenu.stopMusic()
                }
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
