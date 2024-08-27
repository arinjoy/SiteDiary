import SwiftUI

struct DropdownTextField: View {

    var title: String
    var dropdownInputs: [String]
    @Binding var inputText: String

    var body: some View {
        HStack {
            TextField(title, text: $inputText)
            Menu {
                ForEach(dropdownInputs, id: \.self){ item in
                    Button(item) {
                        self.inputText = item
                    }
                }
            } label: {
                Image(systemName: "chevron.down")
                    .fontWeight(.semibold)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
            }
        }
        .underlined()
    }
}

#Preview {
    DropdownTextField(
        title: "Title",
        dropdownInputs: ["Item 1", "Item 2"],
        inputText: .constant("Hello"))
    .padding()
}
