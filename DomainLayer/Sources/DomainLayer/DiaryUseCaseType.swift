import Foundation
import Combine
import DataLayer

public protocol DiaryUseCaseType {

    /// Saves a new diary entry item
    func saveDiaryItem(_ item: DiaryItem) -> AnyPublisher<Bool, NetworkError>

}
