import SwiftUI
import PhotosUI
import DataLayer

struct NewDiaryEntryView: View {

    // MARK: - Properties

    @StateObject var viewModel = NewDiaryEntryViewModel()

    @State private var selectedPhotoItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()

    @State private var commentsInput: String = ""
    @State private var tagsInput: String = ""

    @State private var selectedAreaInput = ""
    @State private var selectedTaskCategoryInput = ""

    @State private var linkToExistingEvent = false
    @State private var selectedEventInput = ""

    @FocusState private var isEditing: Bool

    @State private var isShowingSuccessHUD = false

    @State private var isShowingErrorAlert = false
    @State private var shownErrorReason: NewDiaryEntryViewModel.FailureReason?

    // MARK: - UI Body

    public var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        mainHeader

                        photosSection

                        commentsSection

                        detailsSection

                        linkToEventSection

                        nextButton

                        Spacer()
                    }
                    .padding(16)
                }

                if viewModel.state == .loading {
                    fullScreenProgressView
                }

                if isShowingSuccessHUD {
                    successHUDView
                }
            }
            .toolbar { navBarContent }
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.gray.opacity(0.3))
        }
        .onChange(of: selectedPhotoItems) {
            Task {
                selectedImages.removeAll()

                for item in selectedPhotoItems {
                    if let image = try? await item.loadTransferable(type: Image.self) {
                        selectedImages.append(image)
                    }
                }
            }
        }
        .onChange(of: viewModel.state) { _, state in
            if case .success = state {
                clearFormInputs()
                withAnimation {
                    isShowingSuccessHUD = true
                }
            } else if case .failure(let reason) = state {
                isShowingErrorAlert = true
                shownErrorReason = reason
            }
        }
        .alert(isPresented: $isShowingErrorAlert) {
            errorAlert()
        }
    }
}

// MARK: - Private sub views

// MARK: - Nav Bar

private extension NewDiaryEntryView {

    @ToolbarContentBuilder
    var navBarContent: some ToolbarContent {

        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                // TODO: Connect later for routing / dismiss
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
            }
        }

        ToolbarItem(placement: .principal) {
            HStack {

                Spacer().frame(width: 20)

                Text("New Diary")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                    .accessibilityAddTraits(.isHeader)

                Spacer()
            }

        }
    }
}

// MARK: - Section Groups

private extension NewDiaryEntryView {

    @ViewBuilder
    var mainHeader: some View {
        HStack {
            Text(viewModel.headerTitle)
                .font(.title2)
                .fontWeight(.semibold)

            Spacer()

            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
        }
        .foregroundColor(.primary.opacity(0.6))
    }

    @ViewBuilder
    var photosSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 20) {

                groupHeader(title: viewModel.photosSectionHeaderTitle)

                Divider()

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(0..<selectedImages.count, id: \.self) { index in
                            selectedImages[index]
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                    }
                }
                .scrollIndicators(.hidden)

                PhotosPicker(
                    selection: $selectedPhotoItems,
                    matching: .images,
                    preferredItemEncoding: .compatible
                ) {
                    Text(viewModel.addPhotoButtonTitle)
                        .primaryButtonStyle()
                }
            }
        }
    }

    @ViewBuilder
    var commentsSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 20) {

                groupHeader(title: viewModel.commentSectionTitle)

                Divider()

                TextField(viewModel.commentSectionTitle, text: $commentsInput)
                    .underlined()
                    .focused($isEditing)
            }
        }
    }

    @ViewBuilder
    var detailsSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 20) {

                groupHeader(title: viewModel.detailsSectionTitle)

                Divider()

                DropdownTextField(
                    title: viewModel.selectAreaTitle,
                    dropdownInputs: viewModel.listOfAreas,
                    inputText: $selectedAreaInput)
                .focused($isEditing)

                DropdownTextField(
                    title: viewModel.taskCategoryTitle,
                    dropdownInputs: viewModel.listOfTaskCategory,
                    inputText: $selectedTaskCategoryInput)
                .focused($isEditing)

                TextField(viewModel.tagsTitle, text: $tagsInput)
                    .underlined()
                    .focused($isEditing)
            }
        }
    }

    @ViewBuilder
    var linkToEventSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 20) {
                Toggle(isOn: $linkToExistingEvent) {
                    groupHeader(title: viewModel.linkToEventTitle)
                        .tint(.primary)
                }
                .toggleStyle(CheckboxToggleStyle())

                if linkToExistingEvent {
                    DropdownTextField(
                        title: viewModel.selectEventTitle,
                        dropdownInputs: viewModel.listOfEvents,
                        inputText: $selectedEventInput)
                    .focused($isEditing)
                }
            }
        }
    }

    @ViewBuilder
    var nextButton: some View {
        Button(viewModel.saveButtonTitle) {
            clearErrorAlert()

            viewModel.saveDiaryItem(
                from: selectedImages,
                comments: commentsInput,
                area: selectedAreaInput,
                task: selectedTaskCategoryInput,
                tagsString: tagsInput,
                linkedEvent: linkToExistingEvent ? selectedEventInput : nil
            )
        }
        .buttonStyle(PrimaryButtonStyle())
    }

    @ViewBuilder
    var fullScreenProgressView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .black))
            .scaleEffect(2)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .ignoresSafeArea()
            .background(Color.gray.opacity(0.5))
    }

    @ViewBuilder
    var successHUDView: some View {
        HUDView {
            Label(viewModel.savedToDiaryTitle, systemImage: "checkmark.icloud")
        }
        .zIndex(1)
        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                  isShowingSuccessHUD = false
                }
            }
        }
    }
}

// MARK: - Private Helpers

private extension NewDiaryEntryView {

    @ViewBuilder
    func groupHeader(title: String) -> some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
    }

    func errorAlert() -> Alert {
        var title: String = ""
        var message: String = ""
        
        if let errorReason = shownErrorReason {
            switch errorReason {
            case .invalidInput:
                title = viewModel.invalidInputErrorTitle
                message = viewModel.invalidInputErrorMessage
            case .networkIssue(let error):
                title = error.title
                message = error.message
            }
        }

        return Alert(
            title: Text(title),
            message: Text(message),
            dismissButton: .default(Text("OK"))
        )
    }

    func clearFormInputs() {
        isEditing = false

        selectedImages.removeAll()
        commentsInput = ""
        tagsInput = ""
        selectedAreaInput = ""
        selectedTaskCategoryInput = ""
        linkToExistingEvent = false
        selectedEventInput = ""
    }

    func clearErrorAlert() {
        isShowingErrorAlert = false
        shownErrorReason = nil
    }
}

#Preview {
    NewDiaryEntryView()
}
