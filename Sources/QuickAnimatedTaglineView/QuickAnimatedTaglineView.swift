//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 16/05/25.
//

import Foundation
import SwiftUI

public struct QuickAnimatedTaglineView: View {
    private let words: [String]
    @State private var showWords: [Bool] = []
    
    public init(words: [String]) {
        self.words = words
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                Text(word)
                    .font(.title2)
                    .fontWeight(.black)
                    .opacity(showWords.object(index: index) ?? false ? 1 : 0)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .multilineTextAlignment(.center)
        .onAppear {
            showWords = Array(repeating: false, count: words.count)
            
            for (index, _) in words.enumerated() {
                withAnimation(.easeOut(duration: 1.5).delay(0.5 + Double(index) * 0.5)) {
                    showWords[index] = true
                }
            }
        }
    }
}

#Preview {
    QuickAnimatedTaglineView(words: [
        "Banana",
        "Laranja",
        "Morango",
        "Mamão"
    ])
}
