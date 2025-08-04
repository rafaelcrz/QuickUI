//
//  QuickCopyPasteView.swift
//  QuickUI
//
//  Created by Rafael Ramos on 20/06/25.
//

import Foundation
import UIKit
import SwiftUI

public struct QuickCopyPasteView: View {
    private let textToCopy: String
    
    public init(textToCopy: String) {
        self.textToCopy = textToCopy
    }
    
    public var body: some View {
        Button {
            UIPasteboard.general.string = textToCopy
        } label: {
            HStack {
                Text(textToCopy)
                Image(systemName: "document.on.document.fill")
            }
        }.buttonStyle(.bordered)
    }
}

#Preview {
    QuickCopyPasteView(textToCopy: "texto para coiar")
}
