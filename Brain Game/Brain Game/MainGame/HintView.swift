import SwiftUI

struct HintView: View {
    @Binding var cards: [Card]
    @Binding var hintCount: Int

    @State private var showingHint = false

    var body: some View {
        ZStack {
            Button(action: {
                if hintCount > 0 {
                    useHint()
                }
            }) {
                Image(systemName: "lightbulb")
                    .font(.title)
                    .padding()
                    .overlay(
                        ZStack {
                            if hintCount > 0 {
                                // Показ оставшихся подсказок
                                Text("\(hintCount)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Circle().fill(Color.red))
                                    .offset(x: 10, y: -10)
                            }
                        }
                    )
            }
        }
    }

    // Логика использования подсказки
    private func useHint() {
        hintCount -= 1 // Уменьшаем количество подсказок

        // Показываем все карты лицевой стороной на 1 секунду
        for i in cards.indices {
            cards[i].isFaceUp = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            for i in cards.indices {
                cards[i].isFaceUp = false
            }
        }
    }
}
