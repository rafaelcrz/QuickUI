//
//  QuickSheet.swift
//  QuickUI
//
//  Created by Rafael Ramos on 09/05/25.
//

import Foundation
import SwiftUI

public struct QuickSheet {
    let topLeftCornerRadius: CGFloat
    let topRightCornerRadius: CGFloat
    let heightType: QuickSheetHeightType
    let backgroundColor: Color
    
    public init(
        topLeftCornerRadius: CGFloat,
        topRightCornerRadius: CGFloat,
        heightType: QuickSheetHeightType,
        backgroundColor: Color = Color.black.opacity(0.3)
    ) {
        self.topLeftCornerRadius = topLeftCornerRadius
        self.topRightCornerRadius = topRightCornerRadius
        self.heightType = heightType
        self.backgroundColor = backgroundColor
    }
    
    public static var `default`: QuickSheet {
        QuickSheet(
            topLeftCornerRadius: 16,
            topRightCornerRadius: 16,
            heightType: .medium,
            backgroundColor: Color.black.opacity(0.3)
        )
    }
}
