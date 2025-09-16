import SwiftUI

// The ViewModel is part of the UI, so we import SwiftUI
// It doesn't create Views, but it knows about UI-dependent things like Colors, Images etc.

class EmojiMemoryGame: ObservableObject {
    
    private static let emojis = ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙", "🙀", "👹", "😱", "☠️", "🍭"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 8) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<CardView.Card> {
        model.cards
    }
    
    var color: Color {
        .orange
    }
    
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: CardView.Card) {
        model.choose(card)
    }
}
