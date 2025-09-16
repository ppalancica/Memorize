import SwiftUI

struct EmojiMemoryGameView: View {
    
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
                Text("Score: \(viewModel.score)")
                Spacer()
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
            .font(.largeTitle)
        }
        // .background(.yellow)
        .padding()
        // .background(.yellow) - will have different effect
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(spacing)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 3)) {
                        viewModel.choose(card)
                    }
                }
        }
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
