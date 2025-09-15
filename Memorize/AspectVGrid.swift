import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View { // where Item: Identifiable
    
    var items: [Item]
    var aspectRatio: CGFloat = 0
    var content: (Item) -> ItemView // View or some View wont' work
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            // We used to directly provide constants such as 65, 85, 95 for minimum, but not anymore
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            
            columnCount += 1
        } while columnCount < count
        
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
