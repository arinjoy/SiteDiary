import Foundation

public protocol DiaryUseCaseType {

    /// Saves a new diary entry item
    func saveDiaryItem(_ item: DiaryItem) async throws

}
