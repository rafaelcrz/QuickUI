//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 24/03/25.
//

import Foundation
import SwiftUI

public struct QuickNotificationBadgeView: View {
    let count: Int
    let fillColor: Color
    let strokeColor: Color
    let font: Font
    
    public init(
        count: Int,
        font: Font = .footnote,
        fillColor: Color = Color(.systemRed),
        strokeColor: Color = .clear
    ) {
        self.count = count
        self.font = font
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }
    
    public var body: some View {
        Text("\(count)")
            .font(font)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, count > 9 ? 10 : 8) // Ajusta para números maiores
            .padding(.vertical, 4)
            .monospacedDigit()
            .contentTransition(.numericText())
            .animation(.easeInOut, value: count)
            .background(
                Group {
                    if count < 10 {
                        Circle()
                            .fill(fillColor)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(fillColor)
                    }
                }
            )
            .overlay(
                Group {
                    if count < 10 {
                        Circle().stroke(strokeColor, lineWidth: 1)
                    } else {
                        RoundedRectangle(cornerRadius: 12).stroke(strokeColor, lineWidth: 1)
                    }
                }
            )
            .frame(minWidth: 20, minHeight: 20)
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            QuickNotificationBadgeView(count: 3)   // Exemplo: Ícone pequeno (círculo)
            QuickNotificationBadgeView(count: 122)  // Exemplo: Ícone maior (RoundedRectangle)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
