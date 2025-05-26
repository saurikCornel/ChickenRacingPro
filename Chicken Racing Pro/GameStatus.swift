//
//  GameStatus.swift
//  Chicken Racing Pro
//
//  Created by alex on 5/26/25.
//

import Foundation
enum GameStatus: Equatable {
    case standby
    case progressing(Double)
    case finished
    case failure(String) // заменили Error на String
    case noConnection

    static func == (lhs: GameStatus, rhs: GameStatus) -> Bool {
        switch (lhs, rhs) {
        case (.standby, .standby), (.finished, .finished), (.noConnection, .noConnection):
            return true
        case let (.progressing(a), .progressing(b)):
            return abs(a - b) < 0.0001
        case let (.failure(a), .failure(b)):
            return a == b
        default:
            return false
        }
    }

    func isSame(as other: GameStatus) -> Bool {
        switch (self, other) {
        case (.standby, .standby), (.finished, .finished), (.noConnection, .noConnection):
            return true
        case let (.progressing(a), .progressing(b)):
            return abs(a - b) < 0.0001
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
}
