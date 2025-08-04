//
//  File.swift
//  QuickUI
//
//  Created by Rafael Ramos on 01/04/25.
//

import Foundation
import SwiftUI
import WebKit

public struct QuickWebView: View {
    private let url: URL
    private let backgroundColor: Color
    
    public init(url: URL, backgroundColor: Color = .white) {
        self.url = url
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        WKWebViewepresentable(url: url, backgroundColor: backgroundColor)
            .ignoresSafeArea(.all)
    }
}

struct WKWebViewepresentable: UIViewRepresentable {
    let url: URL
    let backgroundColor: Color
    
    func makeUIView(context: Context) -> WKWebView {
        let webview: WKWebView = WKWebView()
        webview.backgroundColor = UIColor(backgroundColor)
        webview.isOpaque = false
        webview.evaluateJavaScript("document.body.style.background = 'transparent';")
        return webview
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        var request: URLRequest = .init(url: url)
        request.cachePolicy = .reloadRevalidatingCacheData
        webView.load(request)
    }
}

struct QuickWebView_Previews: PreviewProvider {
    static var previews: some View {
        QuickWebView(
            url: URL(
                string: "https://frank-clarity-905719.framer.app/page"
            )!
        ).padding()
    }
}
