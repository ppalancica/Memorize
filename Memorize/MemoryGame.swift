import Foundation

struct MemoryGame<CardContent> {
    
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [] // Array<Card>()
        // Add numberOfPairsOfCards x 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card {
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
        
        // NOTES:
        //
        // 1. MemorizeGame is completely UI-independent. All Model entities should be UI-independent.
        
        // 2. Actual type for CardContent can be String type for the emojis, but should actually be possible to accept other type (Image etc.).
        //
        //    It's ok to specify even UI-related types, because whoever is going to create the MemorizeGame - will probbaly be in UI.
        //    For instance, a ViewModel is part of the UI, so it can specify a UI type.
    }
}
