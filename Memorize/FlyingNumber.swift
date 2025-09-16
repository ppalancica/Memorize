//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Pavel Palancica  on 16.09.2025.
//

import SwiftUI

struct FlyingNumber: View {
    
    let number: Int
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .foregroundColor(number < 0 ? .red : .green)
                .shadow(color: .black, radius: 1.5, x: 1, y: 1)
        }
    }
}

#Preview {
    FlyingNumber(number: 5)
}
