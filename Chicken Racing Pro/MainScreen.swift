//
//  MainScreen.swift
//  Chicken Racing Pro
//
//  Created by alex on 5/26/25.
//

import Foundation
import SwiftUI

struct MainScreen: View {
    private var url: URL { URL(string: "https://chickenpotato.top/play/")! }
    var body: some View {
        ZStack {
            Color.black
                        .ignoresSafeArea()
            CoreScreen(loader: .init(resourceURL: url))
                
        }
    }
}
