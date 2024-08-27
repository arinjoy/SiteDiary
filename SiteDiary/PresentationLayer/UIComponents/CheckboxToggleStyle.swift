import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                configuration.label
                Spacer()
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .tint(.green)
            }
        })
    }
}
