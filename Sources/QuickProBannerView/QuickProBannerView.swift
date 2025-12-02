//
//  QuickProBannerView.swift
//  QuickUI
//
//  Created by Rafael Ramos on 03/04/25.
//

import Foundation
import SwiftUI

public struct QuickProBannerView: View {
    private let cornerRadius: Double = 20
    private let imageIcon: String
    private let appName: String
    private let buttonTitle: String
    private let description: String
    private let bundle: Bundle
    
    public init(
        imageIcon: String,
        appName: String,
        buttonTitle: String,
        description: String,
        bundle: Bundle
    ) {
        self.imageIcon = imageIcon
        self.appName = appName
        self.buttonTitle = buttonTitle
        self.description = description
        self.bundle = bundle
    }
    
    public var body: some View {
        Group {
            if #available(iOS 26, *) {
                button
//                    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: cornerRadius)) //xcode26
            } else {
                button
            }
        }
    }
    
    @ViewBuilder
    private var button: some View {
        HStack {
            Image(imageIcon, bundle: bundle)
                .resizable()
                .frame(width: 44, height: 46)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(appName) Pro")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            Text(buttonTitle)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.15))
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(cornerRadius)
    }
}

#Preview {
    QuickProBannerView(
        imageIcon: "star",
        appName: "MyApp",
        buttonTitle: "Ver mais",
        description: "Adquira e aproveite todas as funcionalidades.",
        bundle: Bundle.main
    )
}
