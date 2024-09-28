import Foundation

struct Card: Identifiable {
    var id = UUID()
    var emoji: String
    var isFaceUp: Bool
    var isTransparent: Bool = false
    var offset: CGSize = .zero
    var opacity: Double = 1.0
}
