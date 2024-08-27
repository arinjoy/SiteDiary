import SwiftUI

extension View {

    func underlined() -> some View {
        self
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .padding(.top, 35)
                    .foregroundColor(.gray.opacity(0.8))
            )
            .padding(.vertical, 10)
    }
}
