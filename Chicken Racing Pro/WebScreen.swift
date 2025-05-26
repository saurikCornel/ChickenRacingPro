//
//  WebScreen.swift
//  Chicken Racing Pro
//
//  Created by alex on 5/26/25.
//

import Foundation
import SwiftUI
import WebKit



struct WebScreen: UIViewRepresentable {
    @ObservedObject var loader: GameLoader

    func makeCoordinator() -> WebCoordinator {
        WebCoordinator { status in
            DispatchQueue.main.async {
                loader.state = status
            }
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        // Create WKWebView configuration
        let conf = WKWebViewConfiguration()
        conf.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: conf)
        
        // Make WKWebView transparent
        webView.backgroundColor = .clear
        webView.isOpaque = false
        
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Clear website data
        let clear: Set<String> = [
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeLocalStorage
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: clear, modifiedSince: .distantPast) {}
        
        // Set navigation delegate
        webView.navigationDelegate = context.coordinator
        
        // Attach web view to loader
        loader.attachWebView { webView }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let clear: Set<String> = [
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeLocalStorage
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: clear, modifiedSince: .distantPast) {}
    }
}
