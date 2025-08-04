//
//  QuickSheetView.swift
//  QuickUI
//
//  Created by Rafael Ramos on 09/05/25.
//

import Foundation
import SwiftUI

public struct QuickSheetView<Content: View>: View {
    var quickSheet: QuickSheet
    @Binding var isShowing: Bool
    var content: () -> Content
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                quickSheet.backgroundColor
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
            }
            
            content()
                .frame(maxWidth: .infinity)
                .frame(
                    maxHeight: isShowing ? quickSheet.heightType.maxHeight : 0
                )
                .background(.white)
                .cornerRadius(quickSheet.topLeftCornerRadius, corners: .topLeft)
                .cornerRadius(quickSheet.topRightCornerRadius, corners: .topRight)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .opacity(isShowing ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}

#Preview {
    @Previewable @State var isShowing: Bool = false
    Button("Show") {
        isShowing.toggle()
    }
    .modifier(
        QuickSheetModifier(
            isPresented: $isShowing,
            view: {
                Text("Hello, world!")
            }
        )
    )
}
