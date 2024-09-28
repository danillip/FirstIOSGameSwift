import SwiftUI

struct GameSettingsView: View {
    @Binding var isMusicOn: Bool

    var body: some View {
        VStack {
            Toggle("Музыка", isOn: $isMusicOn)
                .padding()
                .onChange(of: isMusicOn) { value in
                    if value {
                        SoundPlayerMainGame.playMusic()
                    } else {
                        SoundPlayerMainGame.stopMusic()
                    }
                }
            Spacer()
        }
        .padding()
        .navigationTitle("Настройки")
    }
}
