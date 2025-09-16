import SwiftUI

struct CardView: View {
    
    typealias Card = MemoryGame<String>.Card
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        Pie(endAngle: .degrees(240))
            .opacity(Constants.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor) // Was 0.01
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(5)
            )
            .padding(Constants.Pie.inset)
            .modifier(Cardify(isFaceUp: card.isFaceUp))
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
    
    // UNUSED
    /* var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: Constants.lineWidth)
                Pie(endAngle: .degrees(240))
                    .opacity(Constants.Pie.opacity)
                    .overlay(
                        Text(card.content)
                            .font(.system(size: Constants.FontSize.largest))
                            .minimumScaleFactor(Constants.FontSize.scaleFactor) // Was 0.01
                            .multilineTextAlignment(.center)
                            .aspectRatio(1, contentMode: .fit)
                            .padding(5)
                    )
                    .padding(Constants.Pie.inset)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    } */
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 5
        
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor: CGFloat = smallest / largest
        }
        
        struct Pie {
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
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
