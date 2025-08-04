//
//  QuickFeedbackGenerator.swift
//  MinimaTask
//
//  Created by Rafael Ramos on 11/03/24.
//

import Foundation
import SwiftUI
import UIKit

public final class QuickFeedbackToogle {
    internal var isEnabled: Bool = false
    
    @MainActor public static let shared: QuickFeedbackToogle = .init()
    
    private init() {}
    
    public func toggle(enabled: Bool) {
        isEnabled = enabled
    }
}

public enum QuickFeedbackGenerator {
    case style(QuickFeedbackStyleType)
    case notification(QuickFeedbackNotificationType)
    case selection
    
    @MainActor public func impact() {
        guard QuickFeedbackToogle.shared.isEnabled else { return }
        
        switch self {
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .style(let feedbackGeneratorType):
            ImpactFeedbackGeneratorFactory(type: feedbackGeneratorType).make().impactOccurred()
        case .notification(let type):
            switch type {
            case .success:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }
    }
}

private struct ImpactFeedbackGeneratorFactory {
    let type: QuickFeedbackStyleType
    
    @MainActor func make() -> UIImpactFeedbackGenerator {
        switch type {
        case .light:
            UIImpactFeedbackGenerator(style: .light)
        case .medium:
            UIImpactFeedbackGenerator(style: .medium)
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy)
        case .soft:
            UIImpactFeedbackGenerator(style: .soft)
        case .rigid:
            UIImpactFeedbackGenerator(style: .rigid)
        }
    }
}

