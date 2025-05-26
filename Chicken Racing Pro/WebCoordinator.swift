//
//  WebCoordinator.swift
//  Chicken Racing Pro
//
//  Created by alex on 5/26/25.
//

import Foundation
import WebKit
import Foundation

class WebCoordinator: NSObject, WKNavigationDelegate {
    private let callback: (WebStatus) -> Void
    private var didStart = false

    init(onStatus: @escaping (WebStatus) -> Void) {
        self.callback = onStatus
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if !didStart { callback(.progressing(0.0)) }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        didStart = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        callback(.finished)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        callback(.failure(error.localizedDescription))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        callback(.failure(error.localizedDescription))
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other && webView.url != nil {
            didStart = true
        }
        decisionHandler(.allow)
    }
}
