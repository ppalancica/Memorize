import SwiftUI

// The ViewModel is part of the UI, so we import SwiftUI
// It doesn't create Views, but it knows about UI-dependent things like Colors, Images etc.

class EmojiMemoryGame {
    
    var model: MemoryGame<String>
    
    init(model: MemoryGame<String>) {
        self.model = model
    }
}
