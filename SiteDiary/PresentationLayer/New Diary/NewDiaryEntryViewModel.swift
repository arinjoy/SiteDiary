import Foundation

@MainActor
class NewDiaryEntryViewModel: ObservableObject {

    // MARK: - Types

    enum ViewState {
        case idle
        case loading
        case success
        case error
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

    var submitButtonTitle: String { "Next" }


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

    func saveDiaryEntry() {

        let newDiaryEntry = DiaryEntry(comments: "Hello", areaName: "some", taskName: "task", tags: ["aa", "bb"], existingEventName: "some", timestamp: Date.now)

        state = .loading

        Task {
            do {
                try await useCase.saveDiaryEntry(newDiaryEntry)
                state = .success
            } catch {
                state = .error
            }
        }
    }

}
