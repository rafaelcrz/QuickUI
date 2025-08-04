//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 05/03/25.
//

import Foundation
import SwiftUI

public struct QuickCardGradientView<Content: View>: View {
    
    private let color: Color
    private let content: Content
    private let height: CGFloat
    private let width: CGFloat
    private let cornerRadius: Double
    
    public init(
        color: Color,
        height: CGFloat = 300,
        width: CGFloat = 300,
        cornerRadius: Double = 20,
        content: () -> Content
    ) {
        self.color = color
        self.height = height
        self.width = width
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color, color.opacity(0.5)
//                            Color(red: 0.5, green: 0.1, blue: 0.1),  // Tom mais claro
//                            Color(red: 0.2, green: 0.05, blue: 0.05) // Tom mais escuro
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(0.3), // Destaque claro
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
//                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
            
            content
        }
        .frame(height: height)
    }
}

struct QuickCardGradientView_Previews: PreviewProvider {
    static var previews: some View {
        QuickCardGradientView(color: Color(.red), content: {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "building.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text("HOME PRICE PREDICTION")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text("See future estimates of your home's value")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.8))
            }
        }).preferredColorScheme(.dark)
    }
}

