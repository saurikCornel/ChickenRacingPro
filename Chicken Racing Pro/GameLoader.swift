//
//  GameLoader.swift
//  Chicken Racing Pro
//
//  Created by alex on 5/26/25.
//

import Foundation
import SwiftUI
import Combine
import WebKit

final class GameLoader: NSObject, ObservableObject {
    @Published var state: WebStatus = .standby
    let resource: URL
    private var bag = Set<AnyCancellable>()
    private var progressPipe = PassthroughSubject<Double, Never>()
    private var webViewClosure: (() -> WKWebView)?

    init(resourceURL: URL) {
        self.resource = resourceURL
        super.init() // <-- Добавь этот вызов
        observeProgression()
    }

    func attachWebView(factory: @escaping () -> WKWebView) {
        webViewClosure = factory
        triggerLoad()
    }

    private func observeProgression() {
        progressPipe
            .removeDuplicates()
            .sink { [weak self] val in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.state = val < 1.0 ? .progressing(val) : .finished
                }
            }
            .store(in: &bag)
    }

    private func triggerLoad() {
        guard let webView = webViewClosure?() else { return }
        let req = URLRequest(url: resource, timeoutInterval: 12)
        DispatchQueue.main.async {
            self.state = .progressing(0)
        }
        webView.navigationDelegate = self // добавьте делегат
        webView.load(req)
        monitor(webView)
    }

    private func monitor(_ webView: WKWebView) {
        webView.publisher(for: \.estimatedProgress)
            .sink { [weak self] prog in
                self?.progressPipe.send(prog)
            }
            .store(in: &bag)
        // Если где-то здесь или в других местах есть обработка ошибок:
        // state = .failure(error) -> state = .failure(error.localizedDescription)
    }

    func setConnectivity(_ available: Bool) {
        if available && state == .noConnection {
            triggerLoad()
        } else if !available {
            state = .noConnection
        }
    }
}

// Добавьте расширение для обработки ошибок WebView
extension GameLoader: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.state = .failure(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.state = .failure(error.localizedDescription)
    }
}
