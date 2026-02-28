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
    @State private var isLoading = true

    public init(url: URL, backgroundColor: Color = .white) {
        self.url = url
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        ZStack {
            WKWebViewRepresentable(
                url: url,
                backgroundColor: backgroundColor,
                isLoading: $isLoading
            )
            .ignoresSafeArea(.all)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(1.2)
            }
        }
    }
}

struct WKWebViewRepresentable: UIViewRepresentable {
    let url: URL
    let backgroundColor: Color
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = UIColor(backgroundColor)
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator
        webView.evaluateJavaScript("document.body.style.background = 'transparent';")
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadRevalidatingCacheData
        webView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var isLoading: Binding<Bool>
        private var hasCompletedFirstLoad = false

        init(isLoading: Binding<Bool>) {
            self.isLoading = isLoading
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if !hasCompletedFirstLoad {
                isLoading.wrappedValue = true
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoading.wrappedValue = false
            hasCompletedFirstLoad = true
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            isLoading.wrappedValue = false
            hasCompletedFirstLoad = true
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            isLoading.wrappedValue = false
            hasCompletedFirstLoad = true
        }
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
