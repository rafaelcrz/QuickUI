//
//  QuickSheetHeightType.swift
//  QuickUI
//
//  Created by Rafael Ramos on 09/05/25.
//

import Foundation
import UIKit

public enum QuickSheetHeightType {
    case large
    case medium
    case height(CGFloat)
    case fraction(CGFloat)
    
    @MainActor
    public var maxHeight: CGFloat {
        switch self {
        case .large:
            return screenHeight * 0.9
        case .medium:
            return screenHeight * 0.5
        case .height(let height):
            return height
        case .fraction(let fraction):
            return screenHeight * fraction
        }
    }
    
    @MainActor
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
}
