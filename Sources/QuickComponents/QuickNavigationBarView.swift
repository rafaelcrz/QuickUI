//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 21/02/25.
//

import Foundation
import SwiftUI

public enum QuickNavigationBarType: Hashable {
    case option(QuickNavigationBar)
    case menu(QuickNavigationBarMenu)
    case space
}

public struct QuickNavigationBar: Identifiable, Hashable {
    public let id: String = UUID().uuidString
    let systemName: String
    let title: String?
    let font: Font
    let action: () -> Void
    
    public init(systemName: String, title: String? = nil, font: Font = .title,  action: @escaping () -> Void) {
        self.systemName = systemName
        self.title = title
        self.font = font
        self.action = action
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: QuickNavigationBar, rhs: QuickNavigationBar) -> Bool {
        lhs.id == rhs.id
    }
}

public struct QuickNavigationBarMenu: Identifiable, Hashable {
    public let id: String = UUID().uuidString
    let systemName: String
    let title: String?
    let font: Font
    let options: [QuickNavigationBar]
    
    public init(systemName: String, title: String?, font: Font = .title, options: [QuickNavigationBar]) {
        self.systemName = systemName
        self.title = title
        self.font = font
        self.options = options
    }
}

public struct QuickNavigationStyle {
    public let height: CGFloat
    public let edge: Edge?
    public let alignment: Alignment
    public let paddingBottom: Double
    public let ignoreSafeArea: Bool
    
    public init(
        height: CGFloat = 100,
        edge: Edge? = nil,
        alignment: Alignment = .center,
        paddingBottom: Double = 0,
        ignoreSafeArea: Bool = true
    ) {
        self.height = height
        self.edge = edge
        self.alignment = alignment
        self.paddingBottom = paddingBottom
        self.ignoreSafeArea = ignoreSafeArea
    }
}

public struct QuickNavigationBarView: View {
    private let style: QuickNavigationStyle
    private let types: [QuickNavigationBarType]
    private let showProgress: Bool
    
    public init(
        types: [QuickNavigationBarType],
        style: QuickNavigationStyle,
        showProgress: Bool = false
    ) {
        self.types = types
        self.style = style
        self.showProgress = showProgress
    }
    
    public var body: some View {
        HStack {
            if showProgress {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(height: 34)
                    .padding(.bottom, style.paddingBottom)
            }
            
            if style.edge != .leading && style.edge == .trailing {
                Spacer()
            }
            
            ForEach(types, id: \.self) { type in
                switch type {
                case .space:
                    Spacer()
                case .menu(let menu):
                    Menu {
                        ForEach(menu.options, id: \.id) { option in
                            Button(action: {
                                withAnimation(.smooth) {
                                    option.action()
                                }
                            }, label: {
                                Label(option.title ?? "", systemImage: option.systemName)
                                    .symbolRenderingMode(.hierarchical)
                                    .fontWeight(.medium)
                                    .font(option.font)
                                    .foregroundStyle(Color(.label))
                            })
                        }
                    } label: {
                        if let title = menu.title {
                            Text(title)
                        } else {
                            Image(systemName: menu.systemName)
                                .symbolRenderingMode(.hierarchical)
                                .fontWeight(.medium)
                                .font(menu.font)
                                .foregroundStyle(Color(.label))
                        }
                    }
                case .option(let option):
                    if let title = option.title, !option.systemName.isEmpty {
                        if #available(iOS 26, *) {
                            Button(action: {
                                withAnimation(.smooth) {
                                    option.action()
                                }
                            }, label: {
                                Label(title, systemImage: option.systemName)
                                    .symbolRenderingMode(.hierarchical)
                                    .fontWeight(.bold)
                                    .font(option.font)
                                    .foregroundStyle(Color(.label))
                            })
                            .buttonStyle(.bordered)
                        } else {
                            Button(action: {
                                withAnimation(.smooth) {
                                    option.action()
                                }
                            }, label: {
                                Label(title, systemImage: option.systemName)
                                    .symbolRenderingMode(.hierarchical)
                                    .fontWeight(.bold)
                                    .font(option.font)
                                    .foregroundStyle(Color(.label))
                            })
                            .buttonStyle(.bordered)
                            .cornerRadius(22)
                        }
                    } else {
                        Button(action: {
                            withAnimation(.smooth) {
                                option.action()
                            }
                        }, label: {
                            Image(systemName: option.systemName)
                                .symbolRenderingMode(.hierarchical)
                                .fontWeight(.medium)
                                .font(option.font)
                                .foregroundStyle(Color(.label))
                        })
                    }
                }
            }
            .padding(.bottom, style.paddingBottom)
            
            if style.edge == .leading {
                Spacer()
            }
        }
        .frame(maxHeight: .infinity, alignment: style.alignment)
        .frame(height: style.height)
        .padding(.trailing)
        .padding(.leading)
        .background {
            QuickVariableBlurView(maxBlurRadius: 10, direction: .blurredTopClearBottom, startOffset: 0)
        }
        .if(style.ignoreSafeArea) { view in
            view.ignoresSafeArea()
        }
    }
}

#Preview {
    ZStack {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: 100, height: 100)
        QuickNavigationBarView(
            types: [
                .option(QuickNavigationBar(systemName: "plus.circle.fill", action: {})),
                .option(QuickNavigationBar(
                    systemName: "plus",
                    title: "Nova Option",
                    font: .body,
                    action: {})),
                .menu(QuickNavigationBarMenu(
                    systemName: "ellipsis.circle.fill",
                    title: nil,
                    options: [
                        QuickNavigationBar(systemName: "plus.circle.fill", title: "Option 1", action: {}),
                        QuickNavigationBar(systemName: "plus.square.fill", title: "Option 2", action: {}),
                        QuickNavigationBar(systemName: "plus.circle", title: "Option 3", action: {})
                    ]
                )),
                .space            ],
            style: QuickNavigationStyle(
                height: 90,
                edge: .trailing,
                alignment: .center,
                paddingBottom: -90,
                ignoreSafeArea: true
            ),
            showProgress: true
        )
    }
}
