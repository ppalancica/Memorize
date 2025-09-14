import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [] // Array<Card>()
        // Add numberOfPairsOfCards x 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable {
        // No need to specify the full name MemoryGame<CardContent.Card
        // Just use Card
        //
        // NOTE: When the == function simply compares all the properties, the function below is automaticaly synthesized
        //
        // static func == (lhs: Card, rhs: Card) -> Bool {
        //    return lhs.isFaceUp == rhs.isFaceUp &&
        //    lhs.isMatched == rhs.isMatched &&
        //    lhs.content == rhs.content
        // }
        
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
        
        var id: String
        
        // NOTES:
        //
        // 1. MemorizeGame is completely UI-independent. All Model entities should be UI-independent.
        
        // 2. Actual type for CardContent can be String type for the emojis, but should actually be possible to accept other type (Image etc.).
        //
        //    It's ok to specify even UI-related types, because whoever is going to create the MemorizeGame - will probbaly be in UI.
        //    For instance, a ViewModel is part of the UI, so it can specify a UI type.
    }
}
