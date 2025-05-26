import Foundation
import SwiftUI

struct LoadingOverlay: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Background()
                
                    .frame(width: geo.size.width, height: geo.size.height)
                VStack {
                    Image(.mainLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.8)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    VStack(spacing: 14) {
                        Text("Loading \(Int(progress * 100))%")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    
                    }
                    .padding(5)
                    .background(.ultraThinMaterial)
                    .cornerRadius(14)
                    
                }
            }
            .scaleEffect(1.01)
        }
    }
}

private struct Background: View {
    var body: some View {
        Image(.loading)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}



#Preview {
    LoadingOverlay(progress: 0.76)
}
