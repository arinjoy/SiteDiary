import Foundation

class NewDiaryEntryViewModel: ObservableObject {

    enum ViewState {
        case idle
        case loading
        case success
        case error
    }

    @Published var state: ViewState = .idle

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

        state = .loading

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.state = .success
        }
    }

}
