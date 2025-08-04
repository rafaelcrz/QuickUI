//
//  View+Extensions.swift
//  QuickUI
//
//  Created by Rafael Ramos on 16/02/25.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder internal func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
