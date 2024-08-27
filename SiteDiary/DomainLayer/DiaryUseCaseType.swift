import Foundation

public protocol DiaryUseCaseType {

    /// Saves a new diary entry
    func saveDiaryEntry(_ entry: DiaryEntry) async throws

}
