import SwiftUI

struct HUDView<Content: View>: View {

  @ViewBuilder let content: Content

  var body: some View {
    content
      .font(.title2)
      .fontWeight(.medium)
      .padding(.horizontal, 12)
      .padding(20)
      .background(
        Capsule()
          .foregroundColor(Color.white)
          .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 5)
      )
  }
}
