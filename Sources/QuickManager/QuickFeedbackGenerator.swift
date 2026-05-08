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
    public private(set) var isEnabled: Bool = false

    @MainActor public static let shared: QuickFeedbackToogle = .init()

    private init() {}

    public func toggle(enabled: Bool) {
        isEnabled = enabled
    }
}

public enum QuickFeedbackGenerator {
    case style(QuickFeedbackStyleType, intensity: CGFloat? = nil)
    case notification(QuickFeedbackNotificationType)
    case selection

    @MainActor public func impact() {
        guard QuickFeedbackToogle.shared.isEnabled else { return }

        switch self {
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .style(let feedbackGeneratorType, let intensity):
            let generator = ImpactFeedbackGeneratorFactory(type: feedbackGeneratorType).make()
            if let intensity {
                let clamped = min(1.0, max(0.0, intensity))
                generator.impactOccurred(intensity: clamped)
            } else {
                generator.impactOccurred()
            }
        case .notification(let type):
            switch type {
            case .success:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
}

// MARK: - Convenience shortcuts

public extension QuickFeedbackGenerator {
    static let success: QuickFeedbackGenerator = .notification(.success)
    static let warning: QuickFeedbackGenerator = .notification(.warning)
    static let error: QuickFeedbackGenerator = .notification(.error)

    static let light: QuickFeedbackGenerator = .style(.light)
    static let medium: QuickFeedbackGenerator = .style(.medium)
    static let heavy: QuickFeedbackGenerator = .style(.heavy)
    static let soft: QuickFeedbackGenerator = .style(.soft)
    static let rigid: QuickFeedbackGenerator = .style(.rigid)
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
