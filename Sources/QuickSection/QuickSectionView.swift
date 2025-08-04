//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 02/03/25.
//

import Foundation
import SwiftUI

public struct QuickSection<Content: View>: View {
    private let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
    }
}

public enum QuickSectionAccessory {
    case text(label: String)
}

public struct QuickSectionView: View {
    private let title: String
    private let description: String?
    private let accessory: QuickSectionAccessory?
    private let actionTap: (() -> Void)?
    
    public init(title: String, description: String?, accessory: QuickSectionAccessory? = nil, actionTap: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.accessory = accessory
        self.actionTap = actionTap
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                if let description {
                    Text(description)
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                }
            }
            
            Spacer()
            
            Group {
                buttonText
            }
        }
    }
    
    @ViewBuilder var buttonText: some View {
        if case .text(let label) = accessory {
            Button(label) {
                actionTap?()
            }
        }
    }
}

#Preview {
    QuickSectionView(
        title: "Título da sessão",
        description: "Descrição que exlica a sessão"
    )
}
