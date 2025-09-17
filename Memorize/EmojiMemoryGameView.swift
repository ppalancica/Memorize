import SwiftUI

struct EmojiMemoryGameView: View {
    
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2 / 3
    private let spacing: CGFloat = 4
    
    var body: some View {
        VStack {
            // ScrollView {
            cards
                .foregroundStyle(viewModel.color)
                // Shuffling is related to User's Intent
                // Better do it in Button's action
                // Implicit Animation (applies to any change to the card, not just shuffling). Clicking a card would Fade In and Fade Out
                // If we remove this line - we lose the nice animation on Card flip
                // .animation(.default, value: viewModel.cards)
                // .background(.red)
            // }
            HStack {
                score
                Spacer()
                shuffle
            }
            .font(.largeTitle)
        }
        // .background(.yellow)
        .padding()
        // .background(.yellow) - will have different effect
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil) // Do not animate changes to this view
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            // withAnimation(.easeInOut(duration: 2)) {
            // withAnimation(.linear(duration: 2)) {
            // withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.5)) {
            withAnimation {
                viewModel.shuffle()
            }
        }
        // .background(Color.blue)
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture {
                        withAnimation { // (.easeInOut(duration: 3))
                            choose(card)
                        }
                    }
                    // .transition(.scale) // .opacity
                    .transition(.offset(
                        x: CGFloat.random(in: -1000...1000),
                        y: CGFloat.random(in: -1000...1000)
                    ))
            }
        }
        .onAppear() {
            // Deal the cards
            withAnimation(.easeInOut(duration: 2)) {
                for card in viewModel.cards {
                    dealt.insert(card.id)
                }
            }
        }
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    private func choose(_ card: Card) {
        let scoreBeforeChoosing = viewModel.score
        viewModel.choose(card)
        let scoreChange = viewModel.score - scoreBeforeChoosing
        lastScoreChange = (scoreChange, causedByCardId: card.id) // Can also omit the second label of the argument
    }
    
    //
    // Card.ID is basically String
    //
    // @State private var lastScoreChange: (amount: Int, causedByCardId: Card.ID) = (amount: 0, causedByCardId: "")
    //
    // The above is same as:
    //
    // @State private var lastScoreChange = (amount: 0, causedByCardId: "")
    //
    // The type of 'lastScoreChange' is (amount: Int, causedByCardId: Card.ID) in both cases
    //
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        
        return card.id == id ? amount : 0
        
        // Can also use the label:
        // let (amount, causedByCardId: id) = lastScoreChange
        
        // Can also do this:
        // return lastScoreChange.1 == card.id ? lastScoreChange.0 : 0
    }
    
    // UNUSED
    // @ViewBuilder
   /* private var cardsV1: some View {
        // let aspectRatio: CGFloat = 2 / 3 - this is not allowed
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: viewModel.cards.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            // We used to directly provide constants such as 65, 85, 95 for minimum, but not anymore
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cards) { card in
                    CardView(card)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }
        .foregroundStyle(.orange)
    } */
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
