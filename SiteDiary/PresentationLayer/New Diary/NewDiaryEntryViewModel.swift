import Foundation
import SwiftUI
import DataLayer

@MainActor
class NewDiaryEntryViewModel: ObservableObject {

    // MARK: - Types

    enum ViewState: Equatable {
        case idle
        case loading
        case success
        case failure(NetworkError)
    }

    @Published var state: ViewState = .idle

    // MARK: - Private Dependency

    private let useCase: DiaryUseCaseType

    // MARK: - Initializer

    init(useCase: DiaryUseCaseType = DiaryUseCase()) {
        self.useCase = useCase
    }

    // MARK: - View helper properties

    // TODO: - Ideally these copies should move into localized strings files
    // SwiftGen can be used to access the copies in typeSafe enums ways.

    var headerTitle: String { "Add to site diary" }

    var photosSectionHeaderTitle: String { "Add photos to site diary" }

    var addPhotoButtonTitle: String { "Add a photo" }

    var commentSectionTitle: String { "Comments" }

    var detailsSectionTitle: String { "Details" }

    var selectAreaTitle: String { "Select Area" }

    var taskCategoryTitle: String { "Task Category" }

    var tagsTitle: String { "Tags" }

    var linkToEventTitle: String { "Link to existing event?" }

    var selectEventTitle: String { "Select an event" }

    var saveButtonTitle: String { "Next" }

    var savedToDiaryTitle: String { "Saved to Diary!" }


    // TODO: These are currently hardcoded elements
    // Ideally they need to passed in or sourced from other module based on the business logic
    // and where these information is being kept in the app

    var listOfAreas: [String]  = ["Area #1",
                                  "Area #2",
                                  "Area #3"]

    var listOfTaskCategory: [String]  = ["Task A",
                                         "Task B",
                                         "Task C"]

    var listOfEvents: [String]  = ["Event 1",
                                   "Event 2",
                                   "Event 3"]


    // MARK: - API methods

    func saveDiaryItem(
        from images: [Image],
        comments: String,
        area: String,
        task: String,
        tagsString: String,
        linkedEvent: String?
    ) {

        let newItem = DiaryItem(
            images: images
                .map { $0.extractedUIImage()?.base64 }
                .compactMap { $0 },
            comments: comments,
            area: area,
            task: task,
            tagsString: tagsString,
            linkedEvent: linkedEvent
        )

        state = .loading

        Task {
            do {
                try await useCase.saveDiaryItem(newItem)
                state = .success
            } catch {
                state = .failure(error as? NetworkError ?? .unknown)
            }
        }
    }

}

// MARK: - Private helpers

/// Converting `SwitUI.Image` into `UIKit.UIImage` is not straight forward
/// This below mechanism is one of doing this
private extension Image {

    @MainActor
    func extractedUIImage(newSize: CGSize = .init(width: 300, height: 300)) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}

private extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}

