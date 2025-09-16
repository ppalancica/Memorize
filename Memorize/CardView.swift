import SwiftUI

struct CardView: View {
    
    typealias Card = MemoryGame<String>.Card
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(5)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    
    // NOTE: cannot use typealias inside #Preview
    //
    // typealias Card = MemoryGame<String>.Card
    //
    
    VStack {
        HStack {
            CardView(CardView.Card(isFaceUp: true, content: "X", id: "TestID1"))
                .aspectRatio(4 / 3, contentMode: .fit)
            CardView(CardView.Card(content: "X", id: "TestID1"))
        }
        HStack {
            CardView(CardView.Card(isFaceUp: true, isMatched: true, content: "This is a very long text and I hope it fits", id: "TestID1"))
            CardView(CardView.Card( isMatched: true, content: "X", id: "TestID1"))
        }
    }
    .padding()
    .foregroundStyle(.green)
}
