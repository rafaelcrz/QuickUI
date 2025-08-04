//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 04/03/25.
//

import Foundation
import SwiftUI

public enum QuickDateButtonType {
    case date
    case time
}

public struct QuickDateButtonView<Content: View>: View {
    @Binding var date: Date
    let type: QuickDateButtonType
    let content: Content
    
    public init(
        date: Binding<Date>,
        type: QuickDateButtonType,
        @ViewBuilder content: () -> Content
    ) {
        self._date = date
        self.type = type
        self.content = content()
    }
    
    public var body: some View {
        Button {} label: {
            content
        }
        .overlay {
            DatePicker(
                "",
                selection: type == .date ? $date : $date,
                displayedComponents: type == .date ? .date : .hourAndMinute
            )
            .blendMode(.destinationOver)
        }
    }
}

struct QuickDateButtonView_Previews: PreviewProvider {
    @State static var date: Date = .now
    static var previews: some View {
        QuickDateButtonView(date: $date, type: .time, content: {
            Text("Teste")
        }).previewLayout(.sizeThatFits)
    }
}
