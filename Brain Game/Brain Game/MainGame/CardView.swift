import SwiftUI

struct CardView: View {
    var card: Card
    var onCardTapped: () -> Void

    var body: some View {
        Text(card.isTransparent ? "" : (card.isFaceUp ? card.emoji : "❓"))
            .font(.largeTitle)
            .frame(width: 60, height: 60)
            .background(card.isTransparent ? Color.clear : Color.blue)
            .cornerRadius(10)
            .onTapGesture {
                onCardTapped()
            }
            .opacity(card.opacity)
    }
}
