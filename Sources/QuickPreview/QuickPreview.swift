//
//  QuickPreview.swift
//  QuickUI
//
//  Created by Rafael Ramos on 29/01/25.
//

import Foundation
import SwiftUI

private struct QuickPreviewModel {
    static let components: [String] = [
        "QuickCircleProgressView"
    ]
}

private struct QuickPreview: View {
    var body: some View {
        List {
            ForEach(QuickPreviewModel.components, id: \.self) { component in
                VStack(alignment: .leading, spacing: 18) {
                    Text(component)
                    QuickCircleProgressView(
                        progress: 0.5,
                        color: Color.red,
                        lineWidth: 6,
                        size: 44
                    ) {
                        Image(systemName: "calendar")
                    }
                }
            }.padding(10)
        }
    }
}

#Preview {
    QuickPreview()
}
