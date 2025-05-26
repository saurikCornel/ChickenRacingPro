//
//  CoreScreen.swift
//  Chicken Racing Pro
//
//  Created by alex on 5/26/25.
//

import Foundation
import SwiftUI
import Foundation

struct CoreScreen: View {
    @StateObject private var loader: GameLoader

    init(loader: GameLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            WebScreen(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
                .cornerRadius(20)
            switch loader.state {
            case .progressing(let percent):
                ChickenRaceProgressIndicator(value: percent)
            case .failure(let err):
                ChickenRace(err: err) // err теперь String
            case .noConnection:
                ChickenRaceOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct ChickenRaceProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            LoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct ChickenRace: View {
    let err: String // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct ChickenRaceOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
