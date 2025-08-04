//
//  ShakeModifier.swift
//  MinimaTask
//
//  Created by Rafael Ramos on 09/02/25.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    public func shake(amount: CGFloat = 10, shakesPerUnit: Int = 3, animatableData: CGFloat) -> some View {
        if animatableData > 0 {
            modifier(QuickShake(amount: amount, shakesPerUnit: shakesPerUnit, animatableData: animatableData))
        } else {
            self
        }
    }
}

struct QuickShake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            )
        )
    }
}
