//
//  QuickTabView.swift
//  QuickUI
//
//  Created by Rafael Ramos on 03/02/25.
//

import Foundation
import SwiftUI

public enum QuickTabItem: Hashable, Equatable {
    case text(String)
    case label(text: String, systemImage: String)
    case systemImage(String, color: Color? = nil)
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .text(let string):
            hasher.combine(string)
        case .label(let text, let systemImage):
            hasher.combine(text)
            hasher.combine(systemImage)
        case .systemImage(let string, let color):
            hasher.combine(string)
            if let color = color {
                hasher.combine(color)
            }
        }
    }
    
    static func previewTexts() -> [Self] {
        [
            .text("Focus"),
            .text("Profile"),
            .text("Sharing"),
            .text("Settings"),
        ]
    }
    
    static func previewSystemImages() -> [Self] {
        [
            .systemImage("house", color: Color.blue),
            .systemImage("music.note", color: Color.red),
            .systemImage("folder", color: Color.green),
            .systemImage("person.circle", color: Color.yellow),
            .systemImage("person.crop.circle", color: Color.purple)
        ]
    }
    
    static func previewLabels() -> [Self] {
        [
            .label(text: "Home", systemImage: "house"),
            .label(text: "Offer", systemImage: "tag"),
            .label(text: "Home1", systemImage: "house"),
            .label(text: "Settings", systemImage: "gearshape")
        ]
    }
}

public struct QuickTabView: View {
    private let size: Double = 60
    private let width: Double?
    private var actionSelected: ((QuickTabItem?) -> Void)?
    private let items: [QuickTabItem]
    private let primaryColor: Color
    @Binding private var selectedTab: QuickTabItem?
    
    public init(
        width: Double? = nil,
        primaryColor: Color,
        items: [QuickTabItem],
        selectedTab: Binding<QuickTabItem?>,
        actionSelected: ((QuickTabItem?) -> Void)? = nil
    ) {
        self.width = width
        self.primaryColor = primaryColor
        self.items = items
        self._selectedTab = selectedTab
        self.actionSelected = actionSelected
    }
    
    private func isSelected(_ tab: QuickTabItem) -> Bool {
        return selectedTab == tab
    }
    
    public var body: some View {
        HStack {
            ForEach(items, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                    actionSelected?(tab)
                    
                }, label: {
                    switch tab {
                    case .label(let text, let systemImage):
                        Group {
                            if isSelected(tab) {
                                Label(text, systemImage: systemImage)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                Label("", systemImage: systemImage)
                            }
                        }
                        .font(.callout)
//                        .font(isSelected(tab) ? Font.callout : Font.title3)
                        .padding(12)
                        .fontWeight(.bold)
                        .background(
                            RoundedRectangle(cornerRadius: size/2)
                                .fill(items.count > 1 ? (isSelected(tab) ? primaryColor : Color.clear) : Color.clear)
                        )
                        .foregroundStyle(
                            items.count > 1 ? (isSelected(tab) ? Color.white : primaryColor) : primaryColor
                        )
                    case .systemImage(let systemImage, let color):
                        Circle()
                            .fill(
                                items.count > 1 ? (isSelected(tab) ? primaryColor : Color.clear) : Color.clear
                            )
                            .scaleEffect(isSelected(tab) ? 1.2 : 1.0)
                            .padding(12)
                            .overlay {
                                Image(systemName: systemImage)
                                    .contentTransition(.symbolEffect(.replace))
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(
                                        items.count > 1 ? (isSelected(tab) ? Color.white : color ?? primaryColor) : color ?? primaryColor
                                    )
                            }
                            .frame(maxWidth: .infinity)
                    case .text(let text):
                        Text(text)
                            .font(.footnote)
                            .scaleEffect(isSelected(tab) ? 1.2 : 1.1)
                            .padding(12)
                            .fontWeight(.bold)
                            .background(
                                RoundedRectangle(cornerRadius: size/2)
                                    .fill(items.count > 1 ? (isSelected(tab) ? primaryColor : Color.clear) : Color.clear)
                            )
                            .foregroundStyle(
                                items.count > 1 ? (isSelected(tab) ? Color.white : primaryColor) : primaryColor
                            )
                    }
                })
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
        //        .frame(maxWidth: .infinity)
        .frame(height: size)
        //        .frame(width: width ?? (Double(items.count) * size))
        .animation(.bouncy(duration: 0.6, extraBounce: 0.2), value: selectedTab)
        .background {
            QuickVariableBlurView(
                direction: VariableBlurDirection.blurredBottomClearTop
            )
        }
        .clipShape(
            RoundedRectangle(cornerRadius: size/2)
        )
        .overlay(content: {
            RoundedRectangle(cornerRadius: size/2)
                .stroke(primaryColor, lineWidth: 1)
        })
    }
}

private struct QuickTabViewSample: View {
    @State private var selectedTab: QuickTabItem? = QuickTabItem.previewLabels()[0]
    
    var body: some View {
        QuickTabView(
            primaryColor: Color(.systemOrange),
            items: QuickTabItem.previewLabels(),
            selectedTab: $selectedTab
        )
    }
}

#Preview {
    ZStack {
        Image(systemName: "house.fill")
            .resizable()
            .frame(width: 200, height: 200)
            .foregroundStyle(Color.green)
        QuickTabViewSample()
    }
}
