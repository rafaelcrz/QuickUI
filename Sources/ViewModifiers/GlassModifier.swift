//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 06/06/25.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    public func applyGlass(primaryColor: Color) -> some View {
        self.modifier(GlassModifier(primaryColor: primaryColor))
    }
}

struct GlassModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private var secondaryColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.02) : primaryColor
    }
    
    private let primaryColor: Color
    
    init(primaryColor: Color) {
        self.primaryColor = primaryColor
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        primaryColor.opacity(0.4),
                        secondaryColor
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.2
                    )
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

#Preview {
    VStack {}
        .frame(width: 100, height: 100)
        .applyGlass(primaryColor: Color.red)
}
