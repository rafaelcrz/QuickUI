//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 01/03/25.
//

import Foundation
import UIKit
import SwiftUI

public enum QuickScreenType {
    case `default`(usingSpace: Bool = false)
    case fullScreenCover(usingSpace: Bool = false)
    case sheet(usingSpace: Bool = false)
    case custom(usingSpace: Bool = false, topPadding: Double)
    
    var usingSpace: Bool {
        switch self {
        case .default(usingSpace: let usingSpace):
            return usingSpace
        case .fullScreenCover(usingSpace: let usingSpace):
            return usingSpace
        case .sheet(usingSpace: let usingSpace):
            return usingSpace
        case .custom(usingSpace: let usingSpace, topPadding: _):
            return usingSpace
        }
    }
    
    var titleTopPadding: Double {
        switch self {
        case .default:
            return 16
        case .fullScreenCover:
            return 26
        case .sheet:
            return 38
        case .custom(_, topPadding: let padding):
            return padding
        }
    }
    
    var contentTopPadding: Double {
        switch self {
        case .default, .custom:
            return 16
        case .fullScreenCover:
            return 26
        case .sheet:
            return 38
        }
    }
    
    var navigationHeight: Double {
        switch self {
        case .default, .custom:
            return 90
        case .fullScreenCover:
            return 60
        case .sheet:
            return 54
        }
    }
}

public struct QuickScreenView<Content: View, Background: View>: View {
    private let quickScreenType: QuickScreenType
    private let content: Content
    private let background: Background
    private let title: String?
    private let subTitle: String?
    private let quickNavigationBarOptions: [QuickNavigationBarType]
    private let edge: Edge?
    private let contentTopPadding: Double?
    private let showProgress: Bool
    @Binding private var selectedTabItem: QuickTabItem?
    private var actionTabItemSelected: ((QuickTabItem?) -> Void)?
    
    
    public init(
        quickScreenType: QuickScreenType,
        title: String?,
        subTitle: String?,
        quickNavigationBarOptions: [QuickNavigationBarType] = [],
        edge: Edge? = .trailing,
        contentTopPadding: Double? = nil,
        showProgress: Bool = false,
        selectedTabItem: Binding<QuickTabItem?>? = nil,
        actionTabItemSelected: ((QuickTabItem?) -> Void)? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder background: () -> Background
    ) {
        self.quickScreenType = quickScreenType
        self.title = title
        self.subTitle = subTitle
        self.quickNavigationBarOptions = quickNavigationBarOptions
        self.edge = edge
        self.contentTopPadding = contentTopPadding
        self.showProgress = showProgress
        self._selectedTabItem = selectedTabItem ?? .constant(nil)
        self.actionTabItemSelected = actionTabItemSelected
        self.content = content()
        self.background = background()
    }
    
    public var body: some View {
        scrollView
        .background(content: {
            background
                .ignoresSafeArea()
        })
        .quickNavigationBar(
            quickNavigationBarOptions,
            style: QuickNavigationStyle(
                height: quickScreenType.navigationHeight,
                edge: edge,
                alignment: .bottom,
                ignoreSafeArea: true
            ),
            showProgress: showProgress
        )
    }
    
    @ViewBuilder private var scrollView: some View {
        GeometryReader { gm in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if title != nil || subTitle != nil {
                        HStack(alignment: .firstTextBaseline) {
                            if let title {
                                Text(title)
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                            }
                            Spacer()
                            if let subTitle {
                                Text(subTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.top, quickScreenType.titleTopPadding + 2)
                    }
                    
                    content
                        .padding(.top, contentTopPadding ?? quickScreenType.contentTopPadding)
                    Spacer()
                }
                .if(quickScreenType.usingSpace, transform: { view in
                    view.frame(height: gm.size.height)
                })
                .scrollIndicators(.hidden)
                .padding(.top, 8)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        QuickScreenView(
            quickScreenType: .custom(usingSpace: true, topPadding: -30),
            title: "Titulo",
            subTitle: "Subtitulo",
            quickNavigationBarOptions: [
                .option(QuickNavigationBar(systemName: "xmark.circle.fill", action: {})),
                .option(QuickNavigationBar(systemName: "xmark.circle.fill", action: {})),
                .menu(QuickNavigationBarMenu(
                    systemName: "ellipsis.circle.fill",
                    title: nil,
                    options: [
                        QuickNavigationBar(systemName: "plus.circle.fill", title: "Option 1", action: {
                            
                        })
                    ]
                ))
            ], contentTopPadding: 0,
            content: {
                Text("teste")
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                Text("teste")
                    .background(Color.green)
                Text("teste")
                    .frame(height: 100)
                    .background(Color.green)
                
            },
            background: {
                Color(.secondarySystemGroupedBackground)
            }
        )
    }
}

struct ContentView1: View {
    var body: some View {
        GeometryReader { gm in  //----> add it here
            ScrollView {
                VStack {
                    HStack {
                        Text("Title")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 60)
                    
                    HStack(alignment: .center) {
                        Text("Header Text")
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(6.5)
                    .padding(.horizontal)
                    Spacer()
                        .frame(height: 60)
                    
                    // I want this to occupy all the remaining space
                    VStack {
                        Text("ABC")
                        
                        Text("DEF")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: gm.size.height) // ----> use it here
                    .background(Color.yellow)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green.ignoresSafeArea())
        }
        .ignoresSafeArea(edges: [.bottom])
    }
}
