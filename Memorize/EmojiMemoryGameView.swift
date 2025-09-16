import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2 / 3
    
    var body: some View {
        VStack {
            // ScrollView {
            cards
                .animation(.default, value: viewModel.cards)
                // .background(.red)
            // }
            Button("Shuffle") {
                viewModel.shuffle()
            }
            // .background(Color.blue)
        }
        // .background(.yellow)
        .padding()
        // .background(.yellow) - will have different effect
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        .foregroundStyle(.orange)
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
