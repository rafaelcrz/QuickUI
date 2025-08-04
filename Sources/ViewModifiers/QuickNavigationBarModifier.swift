//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 23/02/25.
//

import Foundation
import SwiftUI

extension View {
    public func quickNavigationBar(_ types: [QuickNavigationBarType], style: QuickNavigationStyle, showProgress: Bool = false) -> some View {
        modifier(QuickNavigationBarModifier(types: types, style: style, showProgress: showProgress))
    }
}

struct QuickNavigationBarModifier: ViewModifier {
    private let types: [QuickNavigationBarType]
    private let style: QuickNavigationStyle
    private let showProgress: Bool
    
    init(types: [QuickNavigationBarType], style: QuickNavigationStyle, showProgress: Bool) {
        self.types = types
        self.style = style
        self.showProgress = showProgress
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                QuickNavigationBarView(
                    types: types,
                    style: style,
                    showProgress: showProgress
                )
            }
    }
}
