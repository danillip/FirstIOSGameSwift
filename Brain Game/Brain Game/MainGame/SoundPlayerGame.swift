import AVFoundation

struct SoundPlayerMainGame {
    static var audioPlayer: AVAudioPlayer?

    static func playMusic() {
        guard let url = Bundle.main.url(forResource: "MainGameSound", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // Зацикливаем
            audioPlayer?.play()
        } catch {
            print("Ошибка воспроизведения музыки: \(error)")
        }
    }

    static func stopMusic() {
        audioPlayer?.stop()
    }
}
