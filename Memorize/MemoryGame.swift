import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [] // Array<Card>()
        // Add numberOfPairsOfCards x 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
    }
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    /* private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            var faceUpCardIndices: [Int] = []
            for index in cards.indices {
                if cards[index].isFaceUp {
                    faceUpCardIndices.append(index)
                }
            }
            if faceUpCardIndices.count == 1 {
                return faceUpCardIndices.first
            } else {
                return nil
            }
        }
        set {
            for index in cards.indices {
                if index == newValue {
                    cards[index].isFaceUp = true
                } else {
                    cards[index].isFaceUp = false
                }
            }
        }
    } */
    
    mutating func choose(_ card: Card) {
        // card.isFaceUp.toggle() won't work, cause card is a copy and a let
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                
                cards[chosenIndex].isFaceUp = true
            }
            
            // cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    // UNUSED
    private func index(of card: Card) -> Int? {
        for index in cards.indices {
            if cards[index].id == card.id {
                return index
            }
        }
        return nil
    }
    
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
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
        
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        
        var hasBeenSeen = false
        
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        
        let content: CardContent
        
        var id: String
        
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
        
        // NOTES:
        //
        // 1. MemorizeGame is completely UI-independent. All Model entities should be UI-independent.
        
        // 2. Actual type for CardContent can be String type for the emojis, but should actually be possible to accept other type (Image etc.).
        //
        //    It's ok to specify even UI-related types, because whoever is going to create the MemorizeGame - will probbaly be in UI.
        //    For instance, a ViewModel is part of the UI, so it can specify a UI type.
        
        // MARK: - Bonus Time
        
        // Call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // Call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // The bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // This gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // Percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime) / bonusTimeLimit : 0
        }
        
        // How long this card has ever been face up and unmatched during its lifetime.
        // Basically, pastFaceUpTime + time since pastFaceUpTime
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // Can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // The last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // The accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
