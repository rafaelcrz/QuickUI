//
//  QuickSheetModifier.swift
//  QuickUI
//
//  Created by Rafael Ramos on 09/05/25.
//

import Foundation
import SwiftUI

public struct QuickSheetModifier<T: View>: ViewModifier {
    @Binding var isPresented: Bool
    var quickSheet: QuickSheet = .default
    
    var view: () -> T
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        ZStack {
            QuickSheetView(quickSheet: quickSheet, isShowing: $isPresented) {
                view()
            }.zIndex(1)
            
            content
        }
    }
}
