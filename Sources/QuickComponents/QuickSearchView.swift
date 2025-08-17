//
//  QuickSearchView.swift
//  QuickUI
//
//  Created by Rafael Ramos on 16/02/25.
//

import Foundation
import SwiftUI

public struct QuickSuggesiton: Identifiable {
    public var id: String { title }
    public let image: Image
    public let title: String
    
    public init(image: Image, title: String) {
        self.image = image
        self.title = title
    }
}

public struct QuickSearchView<Content: View, Background: View>: View {
    @State private var suggestionIsExpanded: Bool = false
    @State private var suggestionFiltered: [QuickSuggesiton] = []
    
    private let suggestionList: [QuickSuggesiton]
    private let showHeader: Bool
    private let showDismissButton: Bool
    private let showSearchBar: Bool
    private let placeholder: String
    private var content: () -> Content
    private var background: () -> Background
    private var dismiss: () -> Void
    @Binding private var termToSearch: String
    
    public init(
        showHeader: Bool = true,
        showDismissButton: Bool = true,
        showSearchBar: Bool = true,
        placeholder: String,
        suggestionList: [QuickSuggesiton],
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping () -> Background,
        dismiss: @escaping () -> Void,
        termToSearch: Binding<String>
    ) {
        self.showHeader = showHeader
        self.showDismissButton = showDismissButton
        self.showSearchBar = showSearchBar
        self.placeholder = placeholder
        self.suggestionList = suggestionList
        self.content = content
        self.background = background
        self.dismiss = dismiss
        self._termToSearch = termToSearch
    }
    
    public var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if showHeader {
                        headerView()
                            .padding(.top)
                            .padding(.top)
                    }
                    
                    if !suggestionList.isEmpty {
                        suggestionsGridView()
                    }
                    
                    content()
                    Spacer()
                }
                .padding()
            }.zIndex(1)
            
            if showSearchBar {
                QuickVariableBlurView(maxBlurRadius: 20, direction: .blurredBottomClearTop, startOffset: 0)
                    .ignoresSafeArea()
                    .frame(height: 65)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .zIndex(1)
                    .overlay(alignment: .bottom) {
                        if #available(iOS 26, *) {
                            textFieldView()
                                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 18))
                                .padding(.horizontal)
                                .padding(.bottom)
                        } else {
                            textFieldView()
                                .padding()
                        }
                    }
            }
            
            background()
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
        }
        .overlay(alignment: .topTrailing, content: {
            if showDismissButton {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white)
                }
                .padding(.trailing)
            }
        })
        .onAppear {
            suggestionFiltered = Array(suggestionList.prefix(4))
            suggestionIsExpanded = false
        }
        .onChange(of: suggestionIsExpanded) { oldValue, newValue in
            withAnimation {
                if newValue {
                    suggestionFiltered = suggestionList
                } else {
                    suggestionFiltered = Array(suggestionList.prefix(4))
                }
            }
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Button("Sugestões") {
                
            }.fontWeight(.bold)
            Spacer()
            Button(suggestionIsExpanded ? "Mostrar Menos" : "Mostrar Mais") {
                suggestionIsExpanded.toggle()
            }
            .fontWeight(.bold)
            .animation(nil, value: suggestionIsExpanded)
        }.foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private func suggestionsGridView() -> some View {
        ZStack {
            LazyVGrid(columns: [
                .init(), .init(), .init(), .init()
            ], content: {
                ForEach(suggestionFiltered) { suggestion in
                    VStack {
                        Button {
                            
                        } label: {
                            suggestion.image
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .padding()
                                .background(Color(.systemGray))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .foregroundStyle(.white)
                        }
                        
                        Text(suggestion.title)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                    }
                }
            })
        }
        .padding()
        .background(Color(.systemGray2).opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    @ViewBuilder
    private func textFieldView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
                .font(.title3)
            TextField(placeholder, text: $termToSearch)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.title3)
            if !termToSearch.isEmpty {
                if #available(iOS 26, *) {
                    clearTermButtonView(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .glassEffect(.regular.interactive())
                } else {
                    clearTermButtonView(systemName: "x.circle.fill")
                        .font(.title2)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if #available(iOS 26, *) {} else {
                Color(.systemGray).opacity(0.5)
            }
        }
        .cornerRadius(18)
    }
    
    @ViewBuilder
    private func clearTermButtonView(
        systemName: String,
        padding: CGFloat = 0
    ) -> some View {
        Button {
            withAnimation(.smooth(duration: 0.5)) {
                termToSearch = ""
            }
        } label: {
            Image(systemName: systemName)
                .padding(padding)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    QuickSearchView(
        showHeader: true,
        placeholder: "Buscar",
        suggestionList: [
            QuickSuggesiton(
                image: Image(systemName: "pc"),
                title: "IA"
            )
        ],
        content: {
            ForEach(0..<100) { index in
                Text("Item \(index)")
                    .padding(4)
            }
        },
        background: {
            Color(.secondarySystemBackground)
        },
        dismiss: {
        },
        termToSearch: .constant("Hello, world")
    )
}
