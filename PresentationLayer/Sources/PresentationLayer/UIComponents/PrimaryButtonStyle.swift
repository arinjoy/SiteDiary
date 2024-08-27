import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .primaryButtonStyle()
    }
}


extension View {
    func primaryButtonStyle() -> some View {
        modifier(PrimaryButton())
    }
}

private struct PrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity)
            .font(.body)
            .fontWeight(.bold)
            .padding()
            .foregroundColor(.white)
            .background(.green)
            .cornerRadius(8)
            .shadow(radius: 6)
    }
}
