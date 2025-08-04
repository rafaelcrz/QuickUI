//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 07/03/25.
//

import Foundation
import SwiftUI

public struct QuickCircleProgressView<Content: View>: View {
    private let progress: Double
    private let color: Color
    private let lineWidth: CGFloat
    private let size: CGFloat
    private let content: Content
    
    public init(
        progress: Double,  
        color: Color,
        lineWidth: CGFloat,
        size: CGFloat,
        content: () -> Content
    ) {
        self.progress = progress
        self.color = color
        self.lineWidth = lineWidth
        self.size = size
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.5))
                .stroke(Color(.label).opacity(1), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .animation(.easeOut , value: progress)
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .overlay {
                    content
                }
        }
    }
}

#Preview {
    QuickCircleProgressView(
        progress: 0.5,
        color: Color(.systemRed),
        lineWidth: 12,
        size: 100) {
            Text("⌛️")
        }
        
}
