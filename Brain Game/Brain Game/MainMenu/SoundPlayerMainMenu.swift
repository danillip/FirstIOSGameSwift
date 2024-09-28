import AVFoundation

class SoundPlayerMainMenu {
    static var audioPlayer: AVAudioPlayer?

    static func playMusic() {
        if let path = Bundle.main.path(forResource: "MainMenuSound", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1  // Бесконечное воспроизведение
                audioPlayer?.play()
            } catch {
                print("Ошибка воспроизведения аудио: \(error.localizedDescription)")
            }
        }
    }

    static func stopMusic() {
        audioPlayer?.stop()
    }
}
