import Foundation

struct MemorizeGame<CardContent> {
    
    var cards: Array<Card>
    
    func choose(card: Card) {
        
    }
    
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
        
        // NOTES:
        //
        // 1. MemorizeGame is completely UI-independent. All Model entities should be UI-independent.
        
        // 2. Actual type for CardContent can be String type for the emojis, but should actually be possible to accept other type (Image etc.).
        //
        //    It's ok to specify even UI-related types, because whoever is going to create the MemorizeGame - will probbaly be in UI.
        //    For instance, a ViewModel is part of the UI, so it can specify a UI type.
    }
}
